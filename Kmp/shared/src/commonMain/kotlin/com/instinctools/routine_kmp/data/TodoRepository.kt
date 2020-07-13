package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.data.auth.AuthRepository
import com.instinctools.routine_kmp.data.firestore.FirebaseTodoStore
import com.instinctools.routine_kmp.data.firestore.error.UnauthorizedFirebaseError
import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.flow.Flow

class TodoRepository(
    private val firebaseTodoStore: FirebaseTodoStore,
    private val localTodoStore: LocalTodoStore,
    private val authRepository: AuthRepository
) {

    fun getTodosSortedByDate(): Flow<List<Todo>> {
        return localTodoStore.getTodosSortedByDate()
    }

    suspend fun getTodoById(todoId: String): Todo? {
        return localTodoStore.getTodoById(todoId)
    }

    suspend fun refresh() {
        val userId = authRepository.requireUserId()
        val fetchedTodos = firebaseTodoStore.fetchTodos(userId)
        localTodoStore.replaceAll(fetchedTodos)
    }

    suspend fun add(todo: Todo) {
        val userId = authRepository.requireUserId()
        val id = firebaseTodoStore.addTodo(userId, todo)
        val todoWithId = todo.copy(id = id)
        localTodoStore.insert(todoWithId)
    }

    suspend fun update(todo: Todo) {
        val userId = authRepository.requireUserId()
        firebaseTodoStore.updateTodo(userId, todo)
        localTodoStore.update(todo)
    }

    suspend fun delete(todoId: String) {
        val userId = authRepository.requireUserId()
        firebaseTodoStore.deleteTodo(userId, todoId)
        localTodoStore.delete(todoId)
    }
}