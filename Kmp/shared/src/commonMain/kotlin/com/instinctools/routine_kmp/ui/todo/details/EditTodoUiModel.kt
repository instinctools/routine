package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.Todo

data class EditTodoUiModel(
    val id: Long? = null,
    val title: String? = null,
    val periodUnit: PeriodUnit? = null,
    val periodValue: Int = 1,
    val nextTimestamp: Long? = null
)

fun Todo.toEditModel() = EditTodoUiModel(id, title, periodUnit, periodValue, nextTimestamp)

fun EditTodoUiModel.buildNewTodoModel(): Todo? {
    val title = title ?: return null
    val nextTimestamp = nextTimestamp ?: 0
    val periodUnit = periodUnit ?: throw IllegalStateException()
    return Todo(title, periodUnit, periodValue, nextTimestamp)
}

fun EditTodoUiModel.buildUpdatedTodoModel(): Todo? {
    val id = id ?: return null
    val title = title ?: return null
    val nextTimestamp = nextTimestamp ?: return null
    val periodUnit = periodUnit ?: throw IllegalStateException()
    return Todo(id, title, periodUnit, periodValue, nextTimestamp)
}