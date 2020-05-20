package com.routine.android.vm

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.asLiveData
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow

@ExperimentalCoroutinesApi
class Status {
    val _state = MutableStateFlow(State.EMPTY)
    val _error = MutableLiveData<Throwable>()

    val error: LiveData<Throwable> = _error
    val state = _state.asLiveData()
}