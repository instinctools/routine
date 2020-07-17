package com.routine.vm.status

import com.routine.data.model.Event
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

@ExperimentalCoroutinesApi
class StatusImpl : Status {

    override val state: MutableStateFlow<Event<State>> = MutableStateFlow(Event(State.EMPTY))
    override val error: MutableStateFlow<Event<Throwable?>> = MutableStateFlow(Event(null))

    var job: Job? = null
}
