package com.instinctools.routine_kmp.ui.todo.details.model

import com.instinctools.routine_kmp.data.date.currentDate
import com.instinctools.routine_kmp.data.date.plus
import com.instinctools.routine_kmp.data.date.timestamp
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.Todo

data class EditableTodoUiModel(
    val id: String? = null,
    val title: String? = null,
    val periodUnit: PeriodUnit? = null,
    val periodValue: Int = 1,
    val periodStrategy: PeriodResetStrategy = PeriodResetStrategy.FromNow,
    val nextTimestamp: Long? = null
)

fun Todo.edit() = EditableTodoUiModel(id, title, periodUnit, periodValue, periodStrategy, nextTimestamp)

fun EditableTodoUiModel.buildNewTodoModel(): Todo {
    val title = checkNotNull(title) { "Title should not be empty" }
    val periodUnit = checkNotNull(periodUnit) { "Period unit should be selected" }
    val nextTimestamp = nextTimestamp ?: currentDate().plus(periodUnit, periodValue).timestamp
    return Todo(title, periodUnit, periodValue, periodStrategy, nextTimestamp)
}

fun EditableTodoUiModel.buildUpdatedTodoModel(): Todo {
    val id = checkNotNull(id) { "Id should not be empty for already existed task" }
    val title = checkNotNull(title) { "Title should not be empty" }
    val nextTimestamp = nextTimestamp ?: currentDate().timestamp
    val periodUnit = checkNotNull(periodUnit) { "Period unit should be selected" }
    return Todo(id, title, periodUnit, periodValue, periodStrategy, nextTimestamp)
}