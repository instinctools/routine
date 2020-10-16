package com.routine.vm

import androidx.hilt.lifecycle.ViewModelInject
import androidx.lifecycle.ViewModel
import com.dropbox.android.external.store4.StoreRequest
import com.routine.data.repo.TodosRepository
import com.routine.vm.status.cache

class SplashViewModel @ViewModelInject constructor(private val todosRepository: TodosRepository) : ViewModel() {

    fun onRefreshClicked() {
        login.run()
    }

    val login by cache {
        todosRepository
            .loginStore
            .stream(StoreRequest.fresh(Any()))
    }
}
