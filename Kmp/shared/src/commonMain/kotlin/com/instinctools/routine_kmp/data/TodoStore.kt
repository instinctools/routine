package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.flow.Flow

interface TodoStore {

    fun getTodos(): Flow<List<Todo>>
    suspend fun insert(todo: Todo)
    suspend fun update(todo: Todo)
}