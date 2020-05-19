package com.instinctools.routine_kmp.ui.todo

import com.instinctools.routine_kmp.model.Todo
import com.instinctools.routine_kmp.model.color.Color

data class TodoUiModel(
    val todo: Todo,
    val color: Color
)