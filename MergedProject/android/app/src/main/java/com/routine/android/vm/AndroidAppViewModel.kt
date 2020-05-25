package com.routine.android.vm

import android.util.Log
import com.dropbox.android.external.store4.ResponseOrigin
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
import kotlinx.coroutines.flow.*

@FlowPreview
@ExperimentalCoroutinesApi
@ExperimentalStdlibApi
class AndroidAppViewModel : StatusViewModel() {

    companion object {
        const val STATUS_GET_TODOS = "STATUS_GET_TODOS"
    }

    private val refreshTodosStateFlow = MutableStateFlow(Any())
    private val removeTodosStateFlow = MutableStateFlow("")

    val todos = refreshTodosStateFlow.flatMapLatest {
        TodosRepository.todosStore
            .stream(StoreRequest.cached("", true))
            .map { list ->
                if (list is StoreResponse.Data) {
                    val newList = Todo.from(list.value
                        .sortedBy { it.timestamp })
                    return@map StoreResponse.Data(newList, list.origin)
                }
                list
            }
    }
    
    val removeTodo = removeTodosStateFlow.filter { it.isNotEmpty() }
        .flatMapLatest {
            TodosRepository.removeTodoStore
                .stream(StoreRequest.fresh(it))
        }
        .onEach {
            if (it is StoreResponse.Data || it is StoreResponse.Loading) {
                removeTodosStateFlow.value = ""
            }
        }

    fun refresh() {
        refreshTodosStateFlow.value = Any()
    }

    fun removeTodo(todo: Todo) {
        removeTodosStateFlow.value = todo.id
    }

    fun resetTodo(todo: Todo) {

    }
}