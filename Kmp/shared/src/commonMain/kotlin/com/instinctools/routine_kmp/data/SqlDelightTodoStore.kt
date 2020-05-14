package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.TodoDatabase
import com.instinctools.routine_kmp.model.PeriodType
import com.instinctools.routine_kmp.model.Todo

class SqlDelightTodoStore(
    private val database: TodoDatabase
) : TodoStore {

    override fun getTodos(): List<Todo> {
        return database.todoQueries.selectAll { id, title, period_unit, period_value, next_timestamp ->
            Todo(id, title, PeriodType.DAILY, period_value, next_timestamp)
        }.executeAsList()
    }

    override fun insert(todo: Todo) {
        database.todoQueries.insertTodo(todo.title, todo.periodType.id, todo.periodValue, todo.nextTimestamp)
    }

    override fun update(todo: Todo) {
        database.todoQueries.updateTodoById(todo.title, todo.periodType.id, todo.periodValue, todo.nextTimestamp, todo.id)
    }
}