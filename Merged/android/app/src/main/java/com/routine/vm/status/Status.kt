package com.routine.vm.status

import com.routine.data.model.Event
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.StateFlow

@ExperimentalCoroutinesApi
interface Status {
    val state: StateFlow<Event<State>>
    val error: StateFlow<Event<Throwable?>>
}
