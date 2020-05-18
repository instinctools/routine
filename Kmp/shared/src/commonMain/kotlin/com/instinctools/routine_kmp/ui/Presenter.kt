package com.instinctools.routine_kmp.ui

import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.flow.Flow

abstract class Presenter<State, Event> {

    val scope = CoroutineScope(Dispatchers.Default + SupervisorJob())

    // TODO replace with StateFlow and EventFlow when available in `native-mt` branch
    abstract val states: Flow<State>
    abstract val events: SendChannel<Event>

    fun stop() {
        scope.cancelChildren()
    }
}