package com.routine.android.vm.status

import com.routine.android.data.model.Event
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

@ExperimentalCoroutinesApi
class StatusImpl : Status {
    override val state: MutableStateFlow<Event<State>>
        get() = MutableStateFlow(Event(State.EMPTY))
    override val error: MutableStateFlow<Event<Throwable?>>
        get() = MutableStateFlow(Event(null))

    var job: Job? = null
}