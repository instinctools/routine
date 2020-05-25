package com.routine.android.vm

import com.dropbox.android.external.store4.StoreRequest
import com.dropbox.android.external.store4.StoreResponse
import com.routine.android.data.model.Todo
import com.routine.android.data.repo.TodosRepository
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
    private val removeTodoStateFlow = MutableStateFlow("")
    private val resetTodoStateFlow = MutableStateFlow("")

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

    private val removeTodo = removeTodoStateFlow.filter { it.isNotEmpty() }
        .flatMapLatest {
            TodosRepository.removeTodoStore
                .stream(StoreRequest.fresh(it))
        }
        .onEach {
            if (it is StoreResponse.Data || it is StoreResponse.Loading) {
                removeTodoStateFlow.value = ""
            }
        }

    private val resetTodo = resetTodoStateFlow.filter { it.isNotEmpty() }
        .flatMapLatest {
            TodosRepository.resetTodoStore
                .stream(StoreRequest.fresh(it))
        }
        .onEach {
            if (it is StoreResponse.Data || it is StoreResponse.Loading) {
                resetTodoStateFlow.value = ""
            }
        }

    val actionTodo = merge(removeTodo, resetTodo)

    fun refresh() {
        refreshTodosStateFlow.value = Any()
    }

    fun removeTodo(todo: Todo) {
        removeTodoStateFlow.value = todo.id
    }

    fun resetTodo(todo: Todo) {
        resetTodoStateFlow.value = todo.id
    }
}