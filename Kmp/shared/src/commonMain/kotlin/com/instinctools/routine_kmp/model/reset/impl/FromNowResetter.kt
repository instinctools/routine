package com.instinctools.routine_kmp.model.reset.impl

import com.instinctools.routine_kmp.model.reset.TodoResetter
import com.instinctools.routine_kmp.model.todo.Todo
import com.instinctools.routine_kmp.util.currentDate
import kotlinx.datetime.plus

class FromNowResetter : TodoResetter {

    override fun reset(todo: Todo): Todo {
        val currentDate = currentDate()
        val nextDate = currentDate.plus(todo.periodValue, todo.periodUnit.dateTimeUnit)
        return todo.copy(nextDate = nextDate)
    }
}