package com.instinctools.routine_kmp.model.reset.impl

import com.instinctools.routine_kmp.data.date.*
import com.instinctools.routine_kmp.model.Todo
import com.instinctools.routine_kmp.model.reset.TodoResetter

class IntervalBasedResetter : TodoResetter {

    override fun reset(todo: Todo): Todo {
        val currentDate = currentDate()
        var nextDate = dateForTimestamp(todo.nextTimestamp)
        do {
            nextDate = nextDate.plus(todo.periodUnit, todo.periodValue)
        } while (nextDate < currentDate)

        return todo.copy(nextTimestamp = nextDate.timestamp)
    }
}