package com.instinctools.routine_kmp.model.reset.impl

import com.instinctools.routine_kmp.model.reset.TodoResetter
import com.instinctools.routine_kmp.model.todo.Todo
import com.instinctools.routine_kmp.util.currentDate
import kotlinx.datetime.plus

class FromNextEventResetter : TodoResetter {

    override fun reset(todo: Todo): Todo {
        val currentDate = currentDate()

        // do not allow increase next event date more then one interval
        val nearestDate = currentDate.plus(todo.periodValue, todo.periodUnit.dateTimeUnit)
        if (todo.nextDate > currentDate && nearestDate < todo.nextDate) {
            return todo
        }

        var nextDate = todo.nextDate
        do {
            nextDate = nextDate.plus(todo.periodValue, todo.periodUnit.dateTimeUnit)
        } while (nextDate < currentDate)

        return todo.copy(nextDate = nextDate)
    }
}