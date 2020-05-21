package com.routine.android.vm.status

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.routine.android.data.model.Event
import kotlinx.coroutines.*

@ExperimentalCoroutinesApi
abstract class StatusViewMode : ViewModel() {

    private val statusMap = mutableMapOf<String, Status>()

    fun process(statusKey: String, data: (suspend () -> Unit)) {
        val status = getStatus(statusKey)
        if (status is StatusImpl) {
            status.job?.cancel()
            val newJob = viewModelScope.launch(CoroutineExceptionHandler { _, throwable ->
                Log.d("TEST123", "process: ERROR")
                status.error.value = Event(throwable)
                status.state.value = Event(State.ERROR)
            }) {
                yield()
                Log.d("TEST123", "process: PROGRESS")
                status.state.value = Event(State.PROGRESS)
                withContext(Dispatchers.IO) {
                    data.invoke()
                }
                Log.d("TEST123", " process: EMPTY")
                status.state.value = Event(State.EMPTY)
            }
            status.job = newJob
        }
    }

    fun getStatus(statusKey: String) = statusMap.getOrPut(statusKey) { StatusImpl() }
}