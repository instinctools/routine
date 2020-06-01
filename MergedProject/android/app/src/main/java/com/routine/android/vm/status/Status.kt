package com.routine.android.vm.status

import com.routine.android.data.model.Event
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.StateFlow

@ExperimentalCoroutinesApi
interface Status {
    val state: StateFlow<Event<State>>
    val error: StateFlow<Event<Throwable?>>
}