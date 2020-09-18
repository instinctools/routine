package com.routine.vm

import androidx.lifecycle.ViewModel
import androidx.lifecycle.asLiveData
import com.dropbox.android.external.store4.StoreRequest
import com.dropbox.android.external.store4.StoreResponse
import com.routine.data.model.Todo
import com.routine.data.repo.TodosRepository
import com.routine.vm.status.getAction
import com.routine.vm.status.wrapWithAction
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.merge

@FlowPreview
@ExperimentalCoroutinesApi
@ExperimentalStdlibApi
class AndroidAppViewModel : ViewModel() {

    companion object {
        const val GET_TODOS = "GET_TODOS"
        const val REMOVE_TODO = "DELETE_TODO"
        const val RESET_TODO = "RESET_TODO"
    }

    private val todos by wrapWithAction(GET_TODOS, Any()) {
        TodosRepository.todosStore
            .stream(StoreRequest.cached(Pair("", true), true))
            .map { list ->
                if (list is StoreResponse.Data) {
                    val newList = Todo.from(list.value
                        .sortedBy { it.timestamp })
                    return@map StoreResponse.Data(newList, list.origin)
                }
                list
            }
    }

    private val removeTodo by wrapWithAction<String, StoreResponse<Boolean>>(REMOVE_TODO) {
        TodosRepository.removeTodoStore
            .stream(StoreRequest.fresh(it))
    }

    private val resetTodo by wrapWithAction<String, StoreResponse<Boolean>>(RESET_TODO) {
        TodosRepository.resetTodoStore
            .stream(StoreRequest.fresh(it))
    }

    val todosData = todos.filter { it is StoreResponse.Data }

    val todosStatus = todos

    val actionTodo = merge(removeTodo, resetTodo)

    fun refresh() {
        getAction<Any>(GET_TODOS)?.proceed(Any())
    }

    fun removeTodo(todo: Todo) {
        getAction<String>(REMOVE_TODO)?.proceed(todo.id)
    }

    fun resetTodo(todo: Todo) {
        getAction<String>(RESET_TODO)?.proceed(todo.id)
    }
}
