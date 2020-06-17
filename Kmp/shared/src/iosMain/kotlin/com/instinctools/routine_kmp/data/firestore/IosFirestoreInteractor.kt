package com.instinctools.routine_kmp.data.firestore

import com.instinctools.routine_kmp.model.Todo

interface IosFirestoreInteractor {

    fun fetchTodos(userId: String, listener: (List<Todo>?, Exception?) -> Unit)
    fun deleteTodo(userId: String, todoId: String, listener: (Exception?) -> Unit)
    fun addTodo(userId: String, todo: Todo, listener: (String?, Exception?) -> Unit)
    fun updateTodo(userId: String, todo: Todo, listener: (Exception?) -> Unit)

    fun obtainUserId(listener: (String?, Exception?) -> Unit)
}