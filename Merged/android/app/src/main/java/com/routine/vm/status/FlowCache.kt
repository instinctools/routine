package com.routine.vm.status

import androidx.collection.ArrayMap
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import java.util.*
import kotlin.properties.ReadOnlyProperty

private const val DEF_ACTION = "DEF_ACTION"

fun <T : Any, R : Any> paramCache(key: String = DEF_ACTION,
                                  initialAction: T? = null,
                                  dispatcher: CoroutineDispatcher = Dispatchers.IO,
                                  function: (T) -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<R>> {
    return CacheProperty(key, initialAction, dispatcher, function)
}

fun <R : Any> cache(key: String = DEF_ACTION,
                    start: Boolean = true,
                    dispatcher: CoroutineDispatcher = Dispatchers.IO,
                    function: () -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<R>> {
    return CacheProperty(key, if (start) Any() else null, dispatcher, { function() })
}

fun <T : Any, R : Any> paramStatusCache(actionKey: String = DEF_ACTION,
                                        initialAction: T? = null,
                                        dispatcher: CoroutineDispatcher = Dispatchers.IO,
                                        function: (T) -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<Status<R>>> {
    return StatusCacheProperty(actionKey, initialAction, dispatcher, function)
}

fun <R : Any> statusCache(actionKey: String = DEF_ACTION,
                          start: Boolean = true,
                          dispatcher: CoroutineDispatcher = Dispatchers.IO,
                          function: () -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<Status<R>>> {
    return StatusCacheProperty(actionKey, if (start) Any() else null, dispatcher, { function() })
}

@Throws(ClassCastException::class)
fun <T> ViewModel.runAction(param: T, actionKey: String = DEF_ACTION) {
    val delegate: Action<*>? = LazyRegistry.find(this, actionKey)
    if (delegate != null) {
        (delegate as Action<T>).run(param)
    }
}

fun ViewModel.repeatAction(actionKey: String = DEF_ACTION) {
    val delegate: Action<*>? = LazyRegistry.find(this, actionKey)
    if (delegate is Action) {
        delegate.repeat()
    }
}

object LazyRegistry {
    private val lazyMap = WeakHashMap<Any, MutableMap<String, Action<*>>>()

    fun <T : Any> register(target: ViewModel, actionKey: String, lazy: Action<T>) {
        lazyMap.getOrPut(target) { ArrayMap() }[actionKey] = lazy
    }

    fun unregister(target: ViewModel, actionKey: String) = lazyMap[target]?.remove(actionKey)

    fun find(target: Any, actionKey: String) = lazyMap[target]?.get(actionKey)
}

interface Action<T> {
    fun run(value: T)

    fun repeat()
}
