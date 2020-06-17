package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.data.firestore.FirebaseTodoStore
import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.flow.Flow

class TodoRepository(
    private val firebaseTodoStore: FirebaseTodoStore,
    private val localTodoStore: LocalTodoStore
) {

    fun getTodosSortedByDate(): Flow<List<Todo>> {
        return localTodoStore.getTodosSortedByDate()
    }

    suspend fun getTodoById(todoId: String): Todo? {
        return localTodoStore.getTodoById(todoId)
    }

    suspend fun refresh() {
        val fetchedTodos = firebaseTodoStore.fetchTodos()
        localTodoStore.replaceAll(fetchedTodos)
    }

    suspend fun add(todo: Todo) {
        val id = firebaseTodoStore.addTodo(todo)
        val todoWithId = todo.copy(id = id)
        localTodoStore.insert(todoWithId)
    }

    suspend fun update(todo: Todo) {
        firebaseTodoStore.updateTodo(todo)
        localTodoStore.update(todo)
    }

    suspend fun delete(todoId: String) {
        firebaseTodoStore.deleteTodo(todoId)
        localTodoStore.delete(todoId)
    }
}