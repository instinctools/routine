package com.routine.vm.status

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.routine.vm.status.cache.Cache
import com.routine.vm.status.cache.CacheHolder
import com.routine.vm.status.cache.ParamCache
import com.routine.vm.status.cache.StatusCacheHolder
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlin.properties.ReadOnlyProperty

fun <R : Any> ViewModel.cache(start: Boolean = true,
                              dispatcher: CoroutineDispatcher = Dispatchers.IO,
                              function: () -> Flow<R>): ReadOnlyProperty<ViewModel, Cache<R>> {
    return CacheHolder(Any(), start, dispatcher, viewModelScope, { function() })
}

fun <T : Any, R : Any> ViewModel.paramCache(initialAction: T? = null,
                                            start: Boolean = true,
                                            dispatcher: CoroutineDispatcher = Dispatchers.IO,
                                            function: (T) -> Flow<R>): ReadOnlyProperty<ViewModel, ParamCache<T, R>> {
    return CacheHolder(initialAction, start, dispatcher, viewModelScope, function)
}

fun <R : Any> ViewModel.statusCache(start: Boolean = true,
                                    dispatcher: CoroutineDispatcher = Dispatchers.IO,
                                    function: () -> Flow<R>): ReadOnlyProperty<ViewModel, Cache<Status<R>>> {
    return StatusCacheHolder(Any(), start, dispatcher, viewModelScope, { function() })
}

fun <T : Any, R : Any> ViewModel.paramStatusCache(initialAction: T,
                                                  start: Boolean = true,
                                                  dispatcher: CoroutineDispatcher = Dispatchers.IO,
                                                  function: (T) -> Flow<R>): ReadOnlyProperty<ViewModel, ParamCache<T, Status<R>>> {
    return StatusCacheHolder(initialAction, start, dispatcher, viewModelScope, function)
}
