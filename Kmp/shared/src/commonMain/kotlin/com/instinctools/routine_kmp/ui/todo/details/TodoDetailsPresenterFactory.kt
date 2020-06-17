package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.data.TodoRepository

class TodoDetailsPresenterFactory(
    private val todoRepository: TodoRepository
) {
    fun create(todoId: String?) = TodoDetailsPresenter(todoId, todoRepository)
}