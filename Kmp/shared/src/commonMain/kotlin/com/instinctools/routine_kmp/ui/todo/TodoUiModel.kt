package com.instinctools.routine_kmp.ui.todo

import com.instinctools.routine_kmp.model.Todo
import com.instinctools.routine_kmp.model.color.TodoColor

data class TodoUiModel(
    val todo: Todo,
    val color: TodoColor
)