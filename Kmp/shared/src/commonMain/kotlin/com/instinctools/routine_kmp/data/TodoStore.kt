package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.model.Todo

interface TodoStore {

    fun getTodos(): List<Todo>
    fun insert(todo: Todo)
    fun update(todo: Todo)
}