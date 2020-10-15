package com.routine.vm.status

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty

class CacheProperty<T : Any, R : Any>(
        private val key: String,
        private var action: T?,
        private val dispatcher: CoroutineDispatcher,
        private val function: (T) -> Flow<R>) : ReadOnlyProperty<ViewModel, Flow<R>>, Action<T> {

    private val flow = MutableStateFlow<T?>(null)
    private val cache = MutableStateFlow<R?>(null)
    private var isInitialized = false
    private val lock = this

    override fun getValue(thisRef: ViewModel,
                          property: KProperty<*>): Flow<R> {
        if (!isInitialized) {
            synchronized(lock) {
                if (!isInitialized) {
                    LazyRegistry.register(thisRef, key, this)
                    flow.filterNotNull()
                        .onStart {
                            action?.let {
                                emit(it)
                            }
                        }
                        .flatMapLatest { function(it) }
                        .onEach { cache.value = it }
                        .onEach { flow.value = null }
                        .onCompletion { LazyRegistry.unregister(thisRef, key) }
                        .flowOn(dispatcher)
                        .launchIn(thisRef.viewModelScope)

                    isInitialized = true
                }
            }
        }
        return cache.filterNotNull()
    }

    override fun run(value: T) {
        flow.value = value
        action = value
    }

    override fun repeat() {
        flow.value = action
    }
}
