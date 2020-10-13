package com.routine.vm.status

import androidx.collection.ArrayMap
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.Flow
import java.util.*
import kotlin.properties.ReadOnlyProperty

private const val DEF_ACTION = "DEF_ACTION"

fun <T : Any, R : Any> ViewModel.paramCache(actionKey: String = DEF_ACTION,
                                            initialAction: T? = null,
                                            function: (T) -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<R>> {
    return CacheProperty(actionKey, initialAction, viewModelScope, function)
}

fun <R : Any> ViewModel.cache(actionKey: String = DEF_ACTION,
                              start: Boolean = true,
                              function: () -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<R>> {
    return CacheProperty(actionKey, if (start) Any() else null, viewModelScope, {
        function()
    })
}

fun <T : Any, R : Any> ViewModel.paramStatusCache(actionKey: String = DEF_ACTION,
                                                  initialAction: T? = null,
                                                  function: (T) -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<Status<R>>> {
    return StatusCacheProperty(actionKey, initialAction, viewModelScope, function)
}

fun <R : Any> ViewModel.statusCache(actionKey: String = DEF_ACTION,
                                    start: Boolean = true,
                                    function: () -> Flow<R>): ReadOnlyProperty<ViewModel, Flow<Status<R>>> {
    return StatusCacheProperty(actionKey, if (start) Any() else null, viewModelScope, {
        function()
    })
}

@Throws(ClassCastException::class)
fun <T> ViewModel.runAction(param: T, actionKey: String = DEF_ACTION) {
    val delegate: Action<*>? = LazyRegistry.find(this, actionKey)
    if (delegate != null) {
        (delegate as? Action<T>)?.run(param)
    }
}

fun ViewModel.repeatAction(actionKey: String = DEF_ACTION) {
    val delegate: Action<*>? = LazyRegistry.find(this, actionKey)
    if (delegate != null) {
        (delegate as? Action)?.repeat()
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
