package com.instinctools.routine_kmp.data.firestore

import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.flow.Flow

expect class FirebaseTodoStore {
    suspend fun fetchTodos(): List<Todo>
    suspend fun deleteTodo(todoId: String)
    suspend fun addTodo(todo: Todo): String
    suspend fun updateTodo(todo: Todo)
}