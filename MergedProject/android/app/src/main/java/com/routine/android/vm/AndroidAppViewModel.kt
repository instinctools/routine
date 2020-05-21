package com.routine.android.vm

import com.dropbox.android.external.store4.StoreRequest
import com.dropbox.android.external.store4.fresh
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.routine.android.data.repo.TodosRepository
import com.routine.android.userIdOrEmpty
import com.routine.android.vm.status.StatusViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview

@FlowPreview
@ExperimentalCoroutinesApi
@ExperimentalStdlibApi
class AndroidAppViewModel : StatusViewModel() {

    companion object {
        const val STATUS_GET_TODOS = "STATUS_GET_TODOS"
    }

    val todos = TodosRepository.todosStore
        .stream(StoreRequest.cached(Firebase.auth.userIdOrEmpty(), true))

    fun retry() {
        process(STATUS_GET_TODOS) {
            TodosRepository.todosStore.fresh(Firebase.auth.userIdOrEmpty())
        }
    }
}