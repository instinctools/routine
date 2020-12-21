package com.instinctools.routine_kmp.data.firestore

import com.instinctools.routine_kmp.model.todo.Todo

expect class FirebaseTodoStore {
    suspend fun fetchTodos(userId: String): List<Todo>
    suspend fun deleteTodo(userId: String, todoId: String)
    suspend fun addTodo(userId: String, todo: Todo): String
    suspend fun updateTodo(userId: String, todo: Todo)
}