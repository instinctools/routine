package com.routine.vm

import androidx.lifecycle.MutableLiveData
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.routine.common.push
import com.routine.vm.status.StatusViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.tasks.await

@ExperimentalCoroutinesApi
class SplashViewModel : StatusViewModel() {

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
