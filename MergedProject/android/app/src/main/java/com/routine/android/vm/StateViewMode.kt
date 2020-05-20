package com.routine.android.vm

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.*

@ExperimentalCoroutinesApi
abstract class StateViewMode : ViewModel() {

    private val statusMap = mutableMapOf<String, Status>()

    fun process(statusKey: String, data: (suspend () -> Unit)) {
        val status = getStatus(statusKey)
        viewModelScope.launch(CoroutineExceptionHandler { _, throwable ->
            status._error.value = throwable
            status._state.value = State.ERROR
        }) {
            status._state.value = State.PROGRESS
            withContext(Dispatchers.IO) {
                data.invoke()
            }
            status._state.value = State.EMPTY
        }
    }

    fun getStatus(statusKey: String) = statusMap.getOrPut(statusKey) { Status() }
}