package com.instinctools.routine_kmp.model.reset.impl

import com.instinctools.routine_kmp.data.date.*
import com.instinctools.routine_kmp.model.Todo
import com.instinctools.routine_kmp.model.reset.TodoResetter

class FromNextEventResetter : TodoResetter {

    override fun reset(todo: Todo): Todo {
        val currentDate = currentDate()
        var nextDate = dateForTimestamp(todo.nextTimestamp)

        // do not allow increase next event date more then one interval
        if (nextDate > currentDate && currentDate.plus(todo.periodUnit, todo.periodValue) < nextDate) {
            return todo
        }

        do {
            nextDate = nextDate.plus(todo.periodUnit, todo.periodValue)
        } while (nextDate < currentDate)

        return todo.copy(nextTimestamp = nextDate.timestamp)
    }
}