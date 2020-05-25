package com.routine.android.vm

import com.dropbox.android.external.store4.StoreRequest
import com.dropbox.android.external.store4.StoreResponse
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.routine.android.data.model.Todo
import com.routine.android.data.repo.TodosRepository
import com.routine.android.userIdOrEmpty
import com.routine.android.vm.status.StatusViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.map

@FlowPreview
@ExperimentalCoroutinesApi
@ExperimentalStdlibApi
class AndroidAppViewModel : StatusViewModel() {

    companion object {
        const val STATUS_GET_TODOS = "STATUS_GET_TODOS"
    }

    private val refreshTodosStateFlow = MutableStateFlow(Any())

    val todos = refreshTodosStateFlow.flatMapLatest {
        TodosRepository.todosStore
            .stream(StoreRequest.cached(Firebase.auth.userIdOrEmpty(), true))
            .map { list ->
                if (list is StoreResponse.Data) {
                    val newList = Todo.from(list.value
                        .sortedBy { it.timestamp })
                    return@map StoreResponse.Data(newList, list.origin)
                }
                list
            }
    }

    fun refresh() {
        refreshTodosStateFlow.value = Any()
    }

    fun removeTodo(todo: Todo) {
    }

    fun resetTodo(todo: Todo) {
    }
}