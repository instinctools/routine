package com.routine.vm.status.cache

import androidx.lifecycle.ViewModel
import com.routine.vm.status.Status
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.*
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty

class StatusCacheHolder<T : Any, R>(
        private var action: T?,
        start: Boolean = true,
        dispatcher: CoroutineDispatcher,
        coroutineScope: CoroutineScope,
        private val function: (T) -> Flow<R>) : Cache<Status<R>>, ParamCache<T, Status<R>>, ReadOnlyProperty<ViewModel, StatusCacheHolder<T, R>> {

    private val flow = MutableStateFlow<T?>(null)

    override val cache = flow.filterNotNull()
        .onStart {
            action?.let {
                if (start) {
                    emit(it)
                }
            }
        }.flatMapLatest {
            flow {
                emit(Status.Loading)
                emitAll(function(it)
                    .map { Status.Data(it) }
                    .catch { emit(Status.Error(it)) })
            }
        }
        .onEach { flow.value = null }
        .flowOn(dispatcher)
        .shareIn(coroutineScope, SharingStarted.Lazily, 1)

    override fun run(value: T) {
        flow.value = value
        action = value
    }

    override fun run() {
        action?.let {
            flow.value = it
        }
    }

    override fun getValue(thisRef: ViewModel, property: KProperty<*>): StatusCacheHolder<T, R> = this
}
