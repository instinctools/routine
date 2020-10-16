package com.routine.vm

import androidx.hilt.lifecycle.ViewModelInject
import androidx.lifecycle.ViewModel
import com.dropbox.android.external.store4.StoreRequest
import com.dropbox.android.external.store4.StoreResponse
import com.routine.data.model.TodoListItem
import com.routine.data.repo.TodosRepository
import com.routine.vm.status.cache
import com.routine.vm.status.paramCache
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.merge

class AndroidAppViewModel @ViewModelInject constructor(private val todosRepository: TodosRepository) : ViewModel() {

    private val todos by cache {
        todosRepository.todosStore
            .stream(StoreRequest.cached(Pair("", true), true))
    }

    private val removeTodo by paramCache<String, StoreResponse<Boolean>> {
        todosRepository.removeTodoStore
            .stream(StoreRequest.fresh(it))
    }

    private val resetTodo by paramCache<String, StoreResponse<Boolean>> {
        todosRepository.resetTodoStore
            .stream(StoreRequest.fresh(it))
    }

    val todosData = todos.cache.filter { it is StoreResponse.Data }
        .map { it as StoreResponse.Data }
        .map { list ->
            val newList = TodoListItem.from(list.value)
            return@map StoreResponse.Data(newList, list.origin)
        }

    val todosStatus = todos

    val actionTodo = merge(removeTodo.cache, resetTodo.cache)

    fun refresh() {
        todos.run()
    }

    fun removeTodo(todo: TodoListItem.Todo) {
        removeTodo.run(todo.id)
    }

    fun resetTodo(todo: TodoListItem.Todo) {
        resetTodo.run(todo.id)
    }
}
