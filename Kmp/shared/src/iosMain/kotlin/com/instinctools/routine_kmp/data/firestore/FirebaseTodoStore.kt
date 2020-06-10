package com.instinctools.routine_kmp.data.firestore

import com.instinctools.routine_kmp.model.Todo

actual class FirebaseTodoStore {

    actual suspend fun fetchTodos(): List<Todo> {
        TODO("Not yet implemented")
    }

    actual suspend fun deleteTodo(todoId: String) {
    }

    actual suspend fun addTodo(todo: Todo): String {
        TODO("Not yet implemented")
    }

    actual suspend fun updateTodo(todo: Todo) {
    }
}