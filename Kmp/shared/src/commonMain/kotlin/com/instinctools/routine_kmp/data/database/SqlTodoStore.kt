package com.instinctools.routine_kmp.data.database

import com.instinctools.routine_kmp.TodoDatabase
import com.instinctools.routine_kmp.data.LocalTodoStore
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.todo.Todo
import com.squareup.sqldelight.runtime.coroutines.asFlow
import com.squareup.sqldelight.runtime.coroutines.mapToList
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.withContext

class SqlTodoStore(
    private val database: TodoDatabase
) : LocalTodoStore {

    private val mapper: (
        id: String,
        title: String,
        period_unit: String,
        period_value: Int,
        period_strategy: String,
        next_timestamp: Long
    ) -> Todo = { id, title, period_unit, period_value, period_strategy, next_timestamp ->
        Todo(id, title, PeriodUnit.find(period_unit), period_value, PeriodResetStrategy.find(period_strategy), next_timestamp)
    }

    override fun getTodos(): Flow<List<Todo>> = database.todoQueries
        .selectAll(mapper)
        .asFlow()
        .mapToList()

    override fun getTodosSortedByDate(): Flow<List<Todo>> = database.todoQueries
        .selectAllSortedByDate(mapper)
        .asFlow()
        .mapToList()

    override suspend fun getTodoById(id: String): Todo? = withContext(Dispatchers.Default) {
        database.todoQueries.selectById(id, mapper).executeAsOneOrNull()
    }

    override suspend fun insert(todo: Todo) = withContext(Dispatchers.Default) {
        database.todoQueries.insertTodo(todo.id, todo.title, todo.periodUnit.id, todo.periodValue, todo.periodStrategy.id, todo.nextTimestamp)
    }

    override suspend fun update(todo: Todo) = withContext(Dispatchers.Default) {
        database.todoQueries.updateById(todo.title, todo.periodUnit.id, todo.periodValue, todo.periodStrategy.id, todo.nextTimestamp, todo.id)
    }

    override suspend fun delete(id: String) = withContext(Dispatchers.Default) {
        database.todoQueries.deleteById(id)
    }

    override suspend fun replaceAll(todos: List<Todo>) {
        database.transaction {
            database.todoQueries.deleteAll()
            for (todo in todos) {
                database.todoQueries.insertTodo(todo.id, todo.title, todo.periodUnit.id, todo.periodValue, todo.periodStrategy.id, todo.nextTimestamp)
            }
        }
    }
}