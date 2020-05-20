package com.routine.android.vm

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.routine.android.data.model.Event
import kotlinx.coroutines.*

@ExperimentalCoroutinesApi
abstract class StateViewMode : ViewModel() {

    private val statusMap = mutableMapOf<String, Status>()

    fun process(statusKey: String, data: (suspend () -> Unit)) {
        val status = getStatus(statusKey)
        status.job?.cancel()
        val newJob = viewModelScope.launch(CoroutineExceptionHandler { _, throwable ->
            status.error.value = Event(throwable)
            status.state.value = Event(State.ERROR)
        }) {
            yield()
            status.state.value = Event(State.PROGRESS)
            withContext(Dispatchers.IO) {
                data.invoke()
            }
            status.state.value = Event(State.EMPTY)
        }
        status.job = newJob
    }

    fun getStatus(statusKey: String) = statusMap.getOrPut(statusKey) { Status() }
}