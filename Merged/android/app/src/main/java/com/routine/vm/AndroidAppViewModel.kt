package com.routine.vm

import androidx.hilt.lifecycle.ViewModelInject
import androidx.lifecycle.ViewModel
import com.dropbox.android.external.store4.StoreRequest
import com.dropbox.android.external.store4.StoreResponse
import com.routine.data.model.TodoListItem
import com.routine.data.repo.TodosRepository
import com.routine.vm.status.cache
import com.routine.vm.status.paramCache
import com.routine.vm.status.repeatAction
import com.routine.vm.status.runAction
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.merge

class AndroidAppViewModel @ViewModelInject constructor(private val todosRepository: TodosRepository) : ViewModel() {

    companion object {
        const val GET_TODOS = "GET_TODOS"
        const val REMOVE_TODO = "DELETE_TODO"
        const val RESET_TODO = "RESET_TODO"
    }

    private val todos by cache(GET_TODOS) {
        todosRepository.todosStore
            .stream(StoreRequest.cached(Pair("", true), true))
    }

    private val removeTodo by paramCache<String, StoreResponse<Boolean>>(REMOVE_TODO) {
        todosRepository.removeTodoStore
            .stream(StoreRequest.fresh(it))
    }

    private val resetTodo by paramCache<String, StoreResponse<Boolean>>(RESET_TODO) {
        todosRepository.resetTodoStore
            .stream(StoreRequest.fresh(it))
    }

    val todosData =
        todos.filter { it is StoreResponse.Data }
            .map { it as StoreResponse.Data }
            .map { list ->
                val newList = TodoListItem.from(list.value)
                return@map StoreResponse.Data(newList, list.origin)
            }

    val todosStatus = todos

    val actionTodo = merge(removeTodo, resetTodo)

    fun refresh() {
        repeatAction(GET_TODOS)
    }

    fun removeTodo(todo: TodoListItem.Todo) {
        runAction(todo.id, REMOVE_TODO)
    }

    fun resetTodo(todo: TodoListItem.Todo) {
        runAction(todo.id, RESET_TODO)
    }
}
