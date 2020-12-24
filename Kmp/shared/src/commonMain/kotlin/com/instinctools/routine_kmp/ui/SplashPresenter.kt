package com.instinctools.routine_kmp.ui

import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.domain.auth.EnsureLoginSideEffect
import com.instinctools.routine_kmp.ui.SplashPresenter.Action
import com.instinctools.routine_kmp.ui.SplashPresenter.State
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class SplashPresenter(
    ensureLoginSideEffect: EnsureLoginSideEffect
) : Store<Action, State>(State.Loading) {

    init {
        registerSideEffect(
            sideEffect = ensureLoginSideEffect,
            inputCreator = { if (it == Action.Login) Unit else null },
            outputConverter = { Action.LoginStateChanged(it) }
        )
        scope.launch {
            delay(1000)
            sendAction(Action.Login)
        }
    }

    override suspend fun reduce(oldState: State, action: Action): State = when (action) {
        Action.Login -> State.Loading
        is Action.LoginStateChanged -> when {
            action.status.progress -> State.Loading
            action.status.error != null -> State.Error(action.status.error)
            else -> State.Success
        }
    }

    sealed class State {
        object Loading : State()
        class Error(val error: Throwable?) : State()
        object Success : State()
    }

    sealed class Action {
        object Login : Action()
        class LoginStateChanged(val status: EffectStatus<Boolean>) : Action()
    }
}