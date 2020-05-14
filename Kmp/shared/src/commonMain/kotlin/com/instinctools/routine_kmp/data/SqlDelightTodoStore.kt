package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.TodoDatabase
import com.instinctools.routine_kmp.model.Todo

class SqlDelightTodoStore(
    private val database: TodoDatabase
) : TodoStore {

    override fun getTodos(): List<Todo> {
        TODO("Not yet implemented")
    }

    override fun insert(todo: Todo) {
        TODO("Not yet implemented")
    }

    override fun update(todo: Todo) {
        TODO("Not yet implemented")
    }
}