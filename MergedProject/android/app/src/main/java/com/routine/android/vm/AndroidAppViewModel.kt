package com.routine.android.vm

import com.dropbox.android.external.store4.StoreRequest
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.routine.android.data.repo.TodosRepository
import com.routine.android.vm.status.StatusViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview

@FlowPreview
@ExperimentalCoroutinesApi
@ExperimentalStdlibApi
class AndroidAppViewModel : StatusViewModel() {

    val todos = TodosRepository.todosStore
        .stream(StoreRequest.cached(Firebase.auth.currentUser?.uid ?: "", true))
}