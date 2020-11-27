package com.instinctools.routine_kmp.model.todo

import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.util.currentDate
import kotlinx.datetime.LocalDate
import kotlinx.datetime.plus

data class EditableTodo(
    val id: String? = null,
    val title: String? = null,
    val periodUnit: PeriodUnit? = null,
    val periodValue: Int = 1,
    val periodStrategy: PeriodResetStrategy = PeriodResetStrategy.FromNow,
    val nextDate: LocalDate? = null
)

fun Todo.edit() = EditableTodo(id, title, periodUnit, periodValue, periodStrategy, nextDate)

fun EditableTodo.toNewTodo(): Todo {
    val title = checkNotNull(title) { "Title should not be empty" }
    val periodUnit = checkNotNull(periodUnit) { "Period unit should be selected" }
    val nextTimestamp = nextDate ?: currentDate().plus(periodValue, periodUnit.dateTimeUnit)
    return Todo(title, periodUnit, periodValue, periodStrategy, nextTimestamp)
}

fun EditableTodo.toExistingTodo(): Todo {
    val id = checkNotNull(id) { "Id should not be empty for already existed task" }
    val title = checkNotNull(title) { "Title should not be empty" }
    val nextDate = nextDate ?: currentDate()
    val periodUnit = checkNotNull(periodUnit) { "Period unit should be selected" }
    return Todo(id, title, periodUnit, periodValue, periodStrategy, nextDate)
}