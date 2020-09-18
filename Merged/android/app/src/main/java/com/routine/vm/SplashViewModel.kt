package com.routine.vm

import androidx.lifecycle.ViewModel
import com.dropbox.android.external.store4.StoreRequest
import com.routine.data.repo.TodosRepository
import com.routine.vm.status.getAction
import com.routine.vm.status.wrapWithAction
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview

@ExperimentalCoroutinesApi
class SplashViewModel : ViewModel() {

    companion object {
        const val ACTION_LOGIN = "ACTION_LOGIN"
    }

    @FlowPreview
    fun onRefreshClicked() {
        getAction<Any>(ACTION_LOGIN)?.proceed(Any())
    }

    @ExperimentalStdlibApi
    @FlowPreview
    val login by wrapWithAction(ACTION_LOGIN, Any()) {
        TodosRepository
            .loginStore
            .stream(StoreRequest.fresh(Any()))
    }
}
