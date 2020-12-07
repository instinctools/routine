package com.instinctools.routine_kmp.ui.todo.list

import com.instinctools.routine_kmp.model.todo.Todo
import com.instinctools.routine_kmp.model.color.TodoColor

data class TodoListUiModel(
    val todo: Todo,
    val color: TodoColor,
    val daysLeft: Int
)