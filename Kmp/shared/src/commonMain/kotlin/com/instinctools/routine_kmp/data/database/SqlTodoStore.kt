package com.instinctools.routine_kmp.data.database

import com.instinctools.routine_kmp.TodoDatabase
import com.instinctools.routine_kmp.data.TodoStore
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.Todo
import com.squareup.sqldelight.runtime.coroutines.asFlow
import com.squareup.sqldelight.runtime.coroutines.mapToList
import kotlinx.coroutines.flow.Flow

class SqlTodoStore(
    private val database: TodoDatabase
) : TodoStore {

    private val mapper: (
        id: Long,
        title: String,
        period_unit: Int,
        period_value: Int,
        next_timestamp: Long
    ) -> Todo = { id, title, period_unit, period_value, next_timestamp ->
        Todo(id, title, PeriodUnit.find(period_unit), period_value, next_timestamp)
    }

    override fun getTodos(): Flow<List<Todo>> = database.todoQueries
        .selectAll(mapper)
        .asFlow()
        .mapToList()

    override fun getTodoById(id: Long): Todo? = database.todoQueries
        .selectById(id, mapper)
        .executeAsOneOrNull()

    override suspend fun insert(todo: Todo) {
        database.todoQueries.insertTodo(todo.title, todo.periodUnit.id, todo.periodValue, todo.nextTimestamp)
    }

    override suspend fun update(todo: Todo) {
        database.todoQueries.updateById(todo.title, todo.periodUnit.id, todo.periodValue, todo.nextTimestamp, todo.id)
    }

    override suspend fun delete(id: Long) {
        database.todoQueries.deleteById(id)
    }
}