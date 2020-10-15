package com.routine.vm.status

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.flow.*
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty

class StatusCacheProperty<T : Any, R : Any>(
        private val key: String,
        private var action: T?,
        private val dispatcher: CoroutineDispatcher,
        private val function: (T) -> Flow<R>) : ReadOnlyProperty<ViewModel, Flow<Status<R>>>, Action<T> {

    private val flow = MutableSharedFlow<T>(extraBufferCapacity = 1)
    private lateinit var cache: Flow<Status<R>>

    override fun getValue(thisRef: ViewModel,
                          property: KProperty<*>): Flow<Status<R>> {

        if (!::cache.isInitialized) {
            LazyRegistry.register(thisRef, key, this)
            cache = flow.onStart {
                action?.let {
                    emit(it)
                }
            }.flatMapLatest {
                flow {
                    emit(Status.Loading)
                    emitAll(function(it)
                        .map { Status.Data(it) }
                        .catch { emit(Status.Error(it)) })
                }
            }
                .onCompletion { LazyRegistry.unregister(thisRef, key) }
                .flowOn(dispatcher)
                .shareIn(thisRef.viewModelScope, SharingStarted.Lazily, 1)
        }
        return cache
    }

    override fun run(value: T) {
        flow.tryEmit(value)
        action = value
    }

    override fun repeat() {
        action?.let {
            flow.tryEmit(it)
        }
    }
}
