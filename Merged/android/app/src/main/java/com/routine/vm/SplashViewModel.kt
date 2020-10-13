package com.routine.vm

import androidx.hilt.lifecycle.ViewModelInject
import androidx.lifecycle.ViewModel
import com.dropbox.android.external.store4.StoreRequest
import com.routine.data.repo.TodosRepository
import com.routine.vm.status.cache
import com.routine.vm.status.findAction

class SplashViewModel @ViewModelInject constructor(private val todosRepository: TodosRepository) : ViewModel() {

    companion object {
        const val ACTION_LOGIN = "ACTION_LOGIN"
    }

    fun onRefreshClicked() {
        findAction<Any>(ACTION_LOGIN)?.proceed(Any())
    }

    val login by cache(ACTION_LOGIN, Any()) {
        todosRepository
            .loginStore
            .stream(StoreRequest.fresh(Any()))
    }
}
