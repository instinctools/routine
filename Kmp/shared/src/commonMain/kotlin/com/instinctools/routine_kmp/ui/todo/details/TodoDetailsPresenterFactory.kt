package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.data.TodoStore

class TodoDetailsPresenterFactory(
    private val todoStore: TodoStore
) {
    fun create(todoId: Long?) = TodoDetailsPresenter(todoId, todoStore)
}