package com.instinctools.routine_kmp.ui

import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

typealias StateListener<State> = (state: State) -> Unit

class UiBinder<Action : Any, State : Any> {

    private val uiScope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    fun bindTo(presenter: Store<Action, State>, listener: StateListener<State>) {
        var oldState: State? = null
        presenter.states
            .onEach { state ->
                listener(state)
                oldState = state
            }
            .launchIn(uiScope)
    }

    fun destroy() {
        uiScope.cancelChildren()
    }
}