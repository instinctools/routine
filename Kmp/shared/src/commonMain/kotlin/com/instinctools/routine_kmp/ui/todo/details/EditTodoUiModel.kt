package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.Todo

data class EditTodoUiModel(
    val id: Long? = null,
    val title: String? = null,
    val periodUnit: PeriodUnit = PeriodUnit.DAY,
    val periodValue: Int = 1
)

fun Todo.toEditModel() = EditTodoUiModel(id, title, periodUnit, periodValue)