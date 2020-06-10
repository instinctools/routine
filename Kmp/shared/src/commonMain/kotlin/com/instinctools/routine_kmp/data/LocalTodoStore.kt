package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.flow.Flow

interface LocalTodoStore {

    fun getTodos(): Flow<List<Todo>>
    fun getTodosSortedByDate(): Flow<List<Todo>>
    suspend fun getTodoById(id: String): Todo?

    suspend fun insert(todo: Todo)
    suspend fun update(todo: Todo)

    suspend fun delete(id: String)
    suspend fun replaceAll(todos: List<Todo>)
}