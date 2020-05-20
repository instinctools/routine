package com.routine

import androidx.lifecycle.MutableLiveData
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.routine.android.push
import com.routine.android.vm.StateViewMode
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.tasks.await

@ExperimentalCoroutinesApi
class SplashViewModel : StateViewMode() {

    val result = MutableLiveData<Boolean>()

    companion object {
        val STATUS_LOGIN = "STATUS_LOGIN"
    }

    private val action: (suspend () -> Unit) = {
        delay(500)
        if (Firebase.auth.currentUser == null) {
            Firebase.auth.signInAnonymously().await()
        }
        result.push(true)
    }

    init {
        process(STATUS_LOGIN, action)
    }

    fun onRefreshClicked() {
        process(STATUS_LOGIN, action)
    }
}