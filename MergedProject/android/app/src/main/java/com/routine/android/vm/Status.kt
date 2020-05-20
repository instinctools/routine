package com.routine.android.vm

import androidx.lifecycle.MutableLiveData
import com.routine.android.data.model.Event
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job

@ExperimentalCoroutinesApi
class Status {
    val state = MutableLiveData(Event(State.EMPTY))
    val error = MutableLiveData<Event<Throwable>>()

    var job: Job? = null
}