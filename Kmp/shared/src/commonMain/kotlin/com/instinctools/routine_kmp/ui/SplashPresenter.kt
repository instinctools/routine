package com.instinctools.routine_kmp.ui

import com.instinctools.routine_kmp.data.auth.AuthRepository
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ConflatedBroadcastChannel
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.launch

class SplashPresenter(
    private val authRepository: AuthRepository
) : Presenter<SplashPresenter.State, SplashPresenter.Event>() {

    private val _states = ConflatedBroadcastChannel<State>()
    override val states: Flow<State> get() = _states.asFlow()

    private val _events = Channel<Event>(Channel.RENDEZVOUS)
    override val events: SendChannel<Event> get() = _events

    override fun start() {
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
                if (event == Event.Retry) {
                    tryLogin()
                }
            }
        }
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

    private fun sendState(newState: State) {
        _states.offer(newState)
    }

    sealed class State {
        object Loading : State()
        class Error(val error: Throwable?) : State()
        object Success : State()
    }

    sealed class Event {
        object Retry : Event()
    }
}