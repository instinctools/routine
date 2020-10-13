package com.routine.vm.status

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.*
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty

class StatusCacheProperty<T : Any, R : Any>(
        val actionKey: String,
        var action: T?,
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
                            action?.let {
                                emit(it)
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

    override fun run(value: T) {
        flow.value = value
        action = value
    }

    override fun repeat() {
        flow.value = action
    }
}
