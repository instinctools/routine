package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.data.date.currentDate
import com.instinctools.routine_kmp.data.date.plus
import com.instinctools.routine_kmp.data.date.timestamp
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.Todo

data class EditTodoUiModel(
    val id: String? = null,
    val title: String? = null,
    val periodUnit: PeriodUnit? = null,
    val periodValue: Int = 1,
    val periodStrategy: PeriodResetStrategy = PeriodResetStrategy.IntervalBased,
    val nextTimestamp: Long? = null
)

fun Todo.toEditModel() = EditTodoUiModel(id, title, periodUnit, periodValue, periodStrategy, nextTimestamp)

fun EditTodoUiModel.buildNewTodoModel(): Todo {
    val title = checkNotNull(title) { "Title should not be empty" }
    val periodUnit = checkNotNull(periodUnit) { "Period unit should be selected" }
    val nextTimestamp = nextTimestamp ?: currentDate().plus(periodUnit, periodValue).timestamp
    return Todo(title, periodUnit, periodValue, periodStrategy, nextTimestamp)
}

fun EditTodoUiModel.buildUpdatedTodoModel(): Todo {
    val id = checkNotNull(id) { "Id should not be empty for already existed task" }
    val title = checkNotNull(title) { "Title should not be empty" }
    val nextTimestamp = nextTimestamp ?: currentDate().timestamp
    val periodUnit = checkNotNull(periodUnit) { "Period unit should be selected" }
    return Todo(id, title, periodUnit, periodValue, periodStrategy, nextTimestamp)
}