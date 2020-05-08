package com.instinctools.routine_android.data.model

import android.graphics.Color
import com.instinctools.routine_android.calculateTargetDate
import com.instinctools.routine_android.data.db.entity.TodoEntity
import com.instinctools.routine_android.pickColorBetween
import com.instinctools.routine_android.prettyPeriod
import org.joda.time.DateTime

data class Todo(
        val id: String,
        val title: String,
        val periodStr: String,
        val targetDate: String,
        val background: Int
) {
    companion object {

        fun from(list: List<TodoEntity>): List<Any> {
            val uiTodos = mutableListOf<Any>()
            val currentDate = DateTime().withTimeAtStartOfDay()
            var lastExpiredTodoFound = false
            var lastExpiredTodoIndex = 0

            for (i in list.indices) {
                val todoTime = DateTime(list[i].timestamp)
                if (!lastExpiredTodoFound && todoTime.isAfter(currentDate)) {
                    if (uiTodos.size > 0) {
                        uiTodos.add(Any())
                        lastExpiredTodoIndex = i - 1;
                    }
                    lastExpiredTodoFound = true
                }
                val color = if (lastExpiredTodoFound) pickColorBetween(i - lastExpiredTodoIndex + 1) else Color.parseColor("#FF0000")
                uiTodos.add(
                        Todo(
                                list[i].id,
                                list[i].title,
                                prettyPeriod(list[i].period, list[i].periodUnit),
                                calculateTargetDate(list[i].timestamp),
                                color
                        )
                )
            }
            return uiTodos
        }
    }
}