package com.routine

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.tasks.await

@ExperimentalCoroutinesApi
class SplashViewModel : ViewModel() {

    val error = MutableLiveData<String>()

    val state = MutableStateFlow(State.EMPTY)

    init {
        process()
    }

    fun process() {
        viewModelScope.launch(CoroutineExceptionHandler { _, throwable ->
            error.value = "Oops, something went wrong!"
            state.value = State.ERROR
        }) {
            state.value = State.PROGRESS
            withContext(Dispatchers.IO) {
                delay(500)
                if (Firebase.auth.currentUser == null) {
                    Firebase.auth.signInAnonymously().await()
                }
                state.value = State.SUCCESS
            }
        }
    }

    enum class State {
        PROGRESS,
        SUCCESS,
        ERROR,
        EMPTY
    }
}