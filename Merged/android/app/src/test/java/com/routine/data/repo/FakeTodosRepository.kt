package com.routine.data.repo

import com.dropbox.android.external.store4.Fetcher
import com.dropbox.android.external.store4.StoreBuilder
import com.routine.data.db.entity.TodoEntity

class FakeTodosRepository: TodosRepository {

    var loginError: Throwable? = null

    override val loginStore = StoreBuilder.from<Any, Boolean>(Fetcher.of {
        loginError?.let {
            throw it
        }
        true
    })
        .disableCache()
        .build()

    override val todosStore = StoreBuilder
        .from(Fetcher.of<Pair<String, Boolean>, List<TodoEntity>>{
            listOf<TodoEntity>()
        })
        .disableCache()
        .build()

    override val removeTodoStore = StoreBuilder.from(Fetcher.of<String, Boolean> { data ->
        true
    })
        .disableCache()
        .build()

    override val resetTodoStore = StoreBuilder.from(Fetcher.of<String, Boolean> {

        true
    })
        .disableCache()
        .build()

    override val getTodoStore = StoreBuilder.from(Fetcher.of<String, TodoEntity> {
        TodoEntity()
    })
        .disableCache()
        .build()

    override val addTodoStore = StoreBuilder.from(Fetcher.of<TodoEntity, Boolean> {

        true
    })
        .disableCache()
        .build()
}