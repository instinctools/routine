package com.routine.data.repo

import com.dropbox.android.external.store4.Store
import com.routine.data.db.entity.TodoEntity

interface TodosRepository {
    val loginStore: Store<Any, Boolean>
    val todosStore: Store<Pair<String, Boolean>, List<TodoEntity>>
    val removeTodoStore: Store<String, Boolean>
    val resetTodoStore: Store<String, Boolean>
    val getTodoStore: Store<String, TodoEntity>
    val addTodoStore: Store<TodoEntity, Boolean>
}
