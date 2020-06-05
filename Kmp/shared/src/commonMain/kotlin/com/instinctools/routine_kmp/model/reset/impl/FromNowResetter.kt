package com.instinctools.routine_kmp.model.reset.impl

import com.instinctools.routine_kmp.data.date.currentDate
import com.instinctools.routine_kmp.data.date.plus
import com.instinctools.routine_kmp.data.date.timestamp
import com.instinctools.routine_kmp.model.Todo
import com.instinctools.routine_kmp.model.reset.TodoResetter

class FromNowResetter : TodoResetter {

    override fun reset(todo: Todo): Todo {
        val currentDate = currentDate()
        val nextDate = currentDate.plus(todo.periodUnit, todo.periodValue)
        return todo.copy(nextTimestamp = nextDate.timestamp)
    }
}