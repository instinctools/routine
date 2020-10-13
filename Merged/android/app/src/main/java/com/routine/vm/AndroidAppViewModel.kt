package com.routine.vm

import androidx.hilt.lifecycle.ViewModelInject
import androidx.lifecycle.ViewModel
import com.dropbox.android.external.store4.StoreRequest
import com.dropbox.android.external.store4.StoreResponse
import com.routine.data.model.TodoListItem
import com.routine.data.repo.TodosRepository
import com.routine.vm.status.cache
import com.routine.vm.status.findAction
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.merge

class AndroidAppViewModel @ViewModelInject constructor(private val todosRepository: TodosRepository): ViewModel() {

    companion object {
        const val GET_TODOS = "GET_TODOS"
        const val REMOVE_TODO = "DELETE_TODO"
        const val RESET_TODO = "RESET_TODO"
    }

    private val todos by cache (GET_TODOS, Any()) {
        todosRepository.todosStore
            .stream(StoreRequest.cached(Pair("", true), true))
    }

    private val removeTodo by cache<String, StoreResponse<Boolean>>(REMOVE_TODO) {
        todosRepository.removeTodoStore
            .stream(StoreRequest.fresh(it))
    }

    private val resetTodo by cache<String, StoreResponse<Boolean>>(RESET_TODO) {
        todosRepository.resetTodoStore
            .stream(StoreRequest.fresh(it))
    }

    val todosData =
        todos.filter { it is StoreResponse.Data }
            .map { it as StoreResponse.Data }
            .map { list ->
                val newList = TodoListItem.from(list.value
                    .sortedBy { it.timestamp })
                return@map StoreResponse.Data(newList, list.origin)
            }


    val todosStatus = todos

    val actionTodo = merge(removeTodo, resetTodo)

    fun refresh() {
        findAction<Any>(GET_TODOS)?.proceed(Any())
    }

    fun removeTodo(todo: TodoListItem.Todo) {
        findAction<String>(REMOVE_TODO)?.proceed(todo.id)
    }

    fun resetTodo(todo: TodoListItem.Todo) {
        findAction<String>(RESET_TODO)?.proceed(todo.id)
    }
}
