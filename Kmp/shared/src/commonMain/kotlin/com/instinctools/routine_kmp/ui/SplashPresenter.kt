package com.instinctools.routine_kmp.ui

import com.instinctools.routine_kmp.data.auth.AuthRepository
import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.ui.SplashPresenter.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class SplashPresenter(
    private val authRepository: AuthRepository
) : Store<Action, State>(State.Loading) {

    init {
        scope.launch {
            val userId = authRepository.getUserId()
            if (userId == null) {
                tryLogin()
            } else {
                // wait a bit for smooth interaction
                delay(400)
                sendState(State.Success)
            }
        }

        scope.launch {
            for (event in _events) {
                if (event == Action.Retry) {
                    tryLogin()
                }
            }
        }
    }

    override suspend fun reduce(oldState: State, action: Action): State {
        TODO("Not yet implemented")
    }

    private suspend fun tryLogin() {
        try {
            delay(200)
            sendState(State.Loading)
            authRepository.loginAnonymously()
            sendState(State.Success)
        } catch (e: Exception) {
            sendState(State.Error(e))
        }
    }

    sealed class State {
        object Loading : State()
        class Error(val error: Throwable?) : State()
        object Success : State()
    }

    sealed class Action {
        object Retry : Action()
    }
}