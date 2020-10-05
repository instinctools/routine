package com.routine.data.model

import android.graphics.Color
import com.routine.App
import com.routine.common.calculateTargetDate
import com.routine.common.pickColorBetween
import com.routine.common.prettyPeriod
import com.routine.data.db.entity.TodoEntity
import org.joda.time.DateTime

sealed class TodoListItem {

    companion object {

        fun from(list: List<TodoEntity>): List<TodoListItem> {
            val uiTodos = mutableListOf<TodoListItem>()
            val currentDate = DateTime().withTimeAtStartOfDay()
            var lastExpiredTodoFound = false
            var lastExpiredTodoIndex = 0

            for (i in list.indices) {
                val todoTime = DateTime(list[i].timestamp)
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
                        list[i].id,
                        list[i].title,
                        prettyPeriod(
                            list[i].period,
                            list[i].periodUnit
                        ),
                        calculateTargetDate(
                            list[i].timestamp
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
        val periodStr: String,
        val targetDate: TargetDate,
        val background: Int
    ): TodoListItem()

    data class TargetDate(val resId: Int, val args: Any?, val quantity: Int)

    class Separator : TodoListItem()
}
