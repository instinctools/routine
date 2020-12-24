package com.instinctools.routine_kmp.domain

import co.touchlab.stately.ensureNeverFrozen
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.channels.BroadcastChannel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.*

abstract class Store<Action, State>(
    initialState: State,
) {

    protected val scope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())

    private val actions = BroadcastChannel<Action>(Channel.BUFFERED)
    private val _states = MutableStateFlow(initialState)

    val states: StateFlow<State> = _states

    init {
        ensureNeverFrozen()

        actions.asFlow()
            .map { reduce(_states.value, it) }
            .onEach { _states.value = it }
            .launchIn(scope)
    }

    protected abstract suspend fun reduce(oldState: State, action: Action): State

    fun sendAction(action: Action) {
        if (!actions.isClosedForSend) actions.offer(action)
    }

    protected fun <Input, Output> registerSideEffect(
        sideEffect: SideEffect<Input, Output>,
        inputCreator: (Action) -> Input?,
        outputConverter: (EffectStatus<Output>) -> Action
    ) {
        actions.asFlow()
            .map { inputCreator(it) }
            .filter { it != null }
            .flatMapConcat { sideEffect.call(it!!) }
            .map { outputConverter(it) }
            .onEach { sendAction(it) }
            .launchIn(scope)
    }

    fun stop() {
        scope.cancelChildren()
    }
}