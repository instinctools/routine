package com.instinctools.routine_kmp.ui.todo.list

import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.todo.Todo
import com.instinctools.routine_kmp.model.color.TodoColor
import kotlinx.datetime.LocalDate

data class TodoListUiModel(
    val todo: Todo,
    val color: TodoColor,
    val daysLeft: Int
) {
    companion object {
        val MOCK = arrayOf(
            TodoListUiModel(
                todo = Todo(
                    id = "adqwenmnva",
                    title = "Exercise",
                    periodUnit = PeriodUnit.DAY,
                    periodValue = 2,
                    periodStrategy = PeriodResetStrategy.FromNow,
                    nextDate = LocalDate(2021, 3, 20)
                ),
                color = TodoColor.EXPIRED_TODO,
                daysLeft = 3
            )
        )
    }
}