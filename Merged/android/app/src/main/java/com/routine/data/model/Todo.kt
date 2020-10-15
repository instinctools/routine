package com.routine.data.model

import android.graphics.Color
import com.routine.common.calculateTargetDate
import com.routine.common.pickColorBetween
import com.routine.common.getPrettyPeriod
import com.routine.data.db.entity.TodoEntity
import org.joda.time.DateTime

sealed class TodoListItem {

    companion object {

        fun from(list: List<TodoEntity>): List<TodoListItem> {
            val uiTodos = mutableListOf<TodoListItem>()
            val currentDate = DateTime().withTimeAtStartOfDay()
            var lastExpiredTodoFound = false
            var lastExpiredTodoIndex = 0

            val sortedList = list.sortedBy { it.timestamp }
            for (i in sortedList.indices) {
                val todoTime = DateTime(sortedList[i].timestamp)
                if (!lastExpiredTodoFound && todoTime.isAfter(currentDate)) {
                    if (uiTodos.size > 0) {
                        uiTodos.add(Separator())
                        lastExpiredTodoIndex = i - 1;
                    }
                    lastExpiredTodoFound = true
                }
                val color = if (lastExpiredTodoFound) pickColorBetween(
                        i - lastExpiredTodoIndex + 1
                ) else Color.parseColor("#FF0000")

                uiTodos.add(
                        Todo(
                                sortedList[i].id,
                                sortedList[i].title,
                                getPrettyPeriod(
                                        sortedList[i].period,
                                        sortedList[i].periodUnit
                                ),
                                calculateTargetDate(
                                        sortedList[i].timestamp
                                ),
                                color
                        )
                )
            }
            return uiTodos
        }
    }

    data class Todo(
        val id: String,
        val title: String,
        val period: ResStringWrapper,
        val targetDate: ResStringWrapper,
        val background: Int
    ): TodoListItem()

    class Separator : TodoListItem()
}

