package com.routine.vm.status

import androidx.collection.ArrayMap
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.*
import java.util.*
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty

const val DEF_ACTION = "DEF_ACTION"

fun <T : Any, R : Any> ViewModel.cache(actionKey: String = DEF_ACTION,
                                       initialAction: T? = null,
                                       function: (T) -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<R>> {
    return Cache(actionKey, initialAction, viewModelScope, function)
}

fun <T : Any, R : Any> ViewModel.statusCache(actionKey: String = DEF_ACTION,
                                             initialAction: T? = null,
                                             function: (T) -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<Status<R>>> {
    return StatusCache(actionKey, initialAction, viewModelScope, function)
}

@Throws(ClassCastException::class)
fun <T> ViewModel.findAction(actionKey: String = DEF_ACTION): Action<T>? {
    val delegate = LazyRegistry.find(this, actionKey)
    if (delegate != null) {
        return delegate as Action<T>
    }
    return delegate
}

private class Cache<T : Any, R : Any>(
        val actionKey: String,
        val initialAction: T?,
        val scope: CoroutineScope,
        val function: (T) -> Flow<R>) : ReadOnlyProperty<ViewModel, Flow<R>>, Action<T> {

    private val flow = MutableStateFlow<T?>(null)
    private val cache = MutableStateFlow<R?>(null)
    private var isInitialized = false
    private val lock = this

    override fun getValue(thisRef: ViewModel,
                          property: KProperty<*>): Flow<R> {
        if (!isInitialized) {
            synchronized(lock) {
                if (!isInitialized) {
                    LazyRegistry.register(thisRef, actionKey, this)
                    flow.filterNotNull()
                        .onStart {
                            if (initialAction != null) {
                                emit(initialAction)
                            }
                        }
                        .flatMapLatest { function(it) }
                        .onEach { cache.value = it }
                        .onEach { flow.value = null }
                        .onCompletion { LazyRegistry.unregister(thisRef, actionKey) }
                        .launchIn(scope)

                    isInitialized = true
                }
            }
        }
        return cache.filterNotNull()
    }

    override fun proceed(value: T) {
        flow.value = value
    }
}

class StatusCache<T : Any, R : Any>(
        val actionKey: String,
        val initialAction: T?,
        val scope: CoroutineScope,
        val function: (T) -> Flow<R>) : ReadOnlyProperty<ViewModel, Flow<Status<R>>>, Action<T> {

    private val flow = MutableStateFlow<T?>(null)
    private val cache = MutableStateFlow<Status<R>?>(null)
    private var isInitialized = false
    private val lock = this

    override fun getValue(thisRef: ViewModel,
                          property: KProperty<*>): Flow<Status<R>> {
        if (!isInitialized) {
            synchronized(lock) {
                if (!isInitialized) {
                    LazyRegistry.register(thisRef, actionKey, this)
                    flow.filterNotNull()
                        .onStart {
                            if (initialAction != null) {
                                emit(initialAction)
                            }
                        }
                        .onEach { cache.value = Status.Loading }
                        .flatMapLatest {
                            function(it).catch {
                                cache.value = Status.Error(it)
                            }
                        }
                        .onEach { cache.value = Status.Data(it) }
                        .onEach { flow.value = null }
                        .onCompletion { LazyRegistry.unregister(thisRef, actionKey) }
                        .launchIn(scope)

                    isInitialized = true
                }
            }
        }
        return cache.filterNotNull()
    }

    override fun proceed(value: T) {
        flow.value = value
    }
}

private object LazyRegistry {
    private val lazyMap = WeakHashMap<Any, MutableMap<String, Action<*>>>()

    fun <T : Any> register(target: ViewModel, actionKey: String, lazy: Action<T>) {
        lazyMap.getOrPut(target) { ArrayMap() }[actionKey] = lazy
    }

    fun unregister(target: ViewModel, actionKey: String) = lazyMap[target]?.remove(actionKey)

    fun find(target: Any, actionKey: String) = lazyMap[target]?.get(actionKey)
}

interface Action<T> {
    fun proceed(value: T)
}
