package com.routine.android.vm.status

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.dropbox.android.external.store4.StoreResponse
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.channels.BroadcastChannel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.*
import java.util.*
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty

const val DEF_ACTION = "DEF_ACTION"

@ExperimentalCoroutinesApi
@FlowPreview
fun <T, R> ViewModel.wrapWithAction(actionKey: String = DEF_ACTION,
                                    initialAction: T? = null,
                                    function: (T) -> Flow<StoreResponse<R>>): ReadOnlyProperty<ViewModel, Flow<StoreResponse<R>>> {
    return Delegate(actionKey, initialAction, viewModelScope, function)
}

@ExperimentalCoroutinesApi
@FlowPreview
@Throws(ClassCastException::class)
fun <T> ViewModel.getAction(actionKey: String): Action<T>? {
    val delegate = LazyRegistry.find(this, actionKey)
    if (delegate != null) {
        return delegate as Action<T>
    }
    return delegate
}

@ExperimentalCoroutinesApi
@FlowPreview
private class Delegate<T, R>(
        val actionKey: String,
        val initialAction: T?,
        val scope: CoroutineScope,
        val function: (T) -> Flow<StoreResponse<R>>) : ReadOnlyProperty<ViewModel, Flow<StoreResponse<R>>>, Action<T> {

    private val channel = BroadcastChannel<T>(Channel.CONFLATED)
    private val cache = MutableStateFlow<StoreResponse<R>?>(null)
    private var isInitialized = false
    private val lock = this

    override fun getValue(thisRef: ViewModel,
                          property: KProperty<*>): Flow<StoreResponse<R>> {
        if (!isInitialized) {
            synchronized(lock) {
                if (!isInitialized) {
                    LazyRegistry.register(thisRef, actionKey, this)
                    channel.asFlow()
                        .onStart {
                            if (initialAction != null) {
                                emit(initialAction)
                            }
                        }
                        .flatMapLatest { function(it) }
                        .onEach { cache.value = it }
                        .launchIn(scope)

                    isInitialized = true
                }
            }
        }
        return cache
            .filter { it != null }
            .map { it!! }
    }

    override fun proceed(value: T) {
        channel.offer(value)
    }
}

@ExperimentalCoroutinesApi
@FlowPreview
private object LazyRegistry {
    private val lazyMap = WeakHashMap<Any, MutableMap<String, Delegate<*, *>>>()

    fun <T, R> register(target: Any, actionKey: String, lazy: Delegate<T, R>) {
        lazyMap.getOrPut(target) { WeakHashMap() }[actionKey] = lazy
    }

    fun find(target: Any, actionKey: String) = lazyMap[target]?.get(actionKey)
}

interface Action<T> {
    fun proceed(value: T)
}