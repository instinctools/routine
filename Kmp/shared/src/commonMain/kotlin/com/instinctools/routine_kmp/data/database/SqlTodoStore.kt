package com.instinctools.routine_kmp.data.database

import com.instinctools.routine_kmp.TodoDatabase
import com.instinctools.routine_kmp.data.TodoStore
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.Todo
import com.squareup.sqldelight.runtime.coroutines.asFlow
import com.squareup.sqldelight.runtime.coroutines.mapToList
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.withContext

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

    override fun getTodosSortedByDate(): Flow<List<Todo>> = database.todoQueries
        .selectAllSortedByDate(mapper)
        .asFlow()
        .mapToList()

    override suspend fun getTodoById(id: Long): Todo? = withContext(Dispatchers.Default) {
        database.todoQueries.selectById(id, mapper).executeAsOneOrNull()
    }

    override suspend fun insert(todo: Todo) = withContext(Dispatchers.Default) {
        database.todoQueries.insertTodo(todo.title, todo.periodUnit.id, todo.periodValue, todo.nextTimestamp)
    }

    override suspend fun update(todo: Todo) = withContext(Dispatchers.Default) {
        database.todoQueries.updateById(todo.title, todo.periodUnit.id, todo.periodValue, todo.nextTimestamp, todo.id)
    }

    override suspend fun delete(id: Long) = withContext(Dispatchers.Default) {
        database.todoQueries.deleteById(id)
    }
}