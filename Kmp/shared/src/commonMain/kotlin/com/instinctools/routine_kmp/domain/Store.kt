package com.instinctools.routine_kmp.domain

import co.touchlab.stately.ensureNeverFrozen
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.channels.BroadcastChannel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

abstract class Store<Action, State>(
    initialState: State,
    sideEffectsTriggers: Array<SideEffectTrigger<*, *, Action, State>>
) {

    protected val scope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())

    private val actions = BroadcastChannel<Action>(Channel.BUFFERED)
    private val _states = MutableStateFlow(initialState)

    val states: StateFlow<State> = _states

    init {
        ensureNeverFrozen()

        scope.launch {
            for (action in actions.openSubscription()) {
                _states.value = reduce(_states.value, action)
            }
        }

        for (sideEffectTrigger in sideEffectsTriggers) {
            actions.asFlow()
                .filter { it in sideEffectTrigger.triggerActions }
                .map { action ->
                    val input = sideEffectTrigger.inputCreator(action, states.value)
                    sideEffectTrigger.sideEffect.call(input)
                }
                .flattenConcat()
                .onEach { output ->
                    val action = sideEffectTrigger.outputCreator(output)
                    actions.send(action)
                }
                .catch { }
                .launchIn(scope)
        }
    }

    abstract suspend fun reduce(oldState: State, action: Action): State

    fun sendAction(action: Action) {
        if (!actions.isClosedForSend) actions.offer(action)
    }

    fun stop() {
        scope.cancelChildren()
    }
}