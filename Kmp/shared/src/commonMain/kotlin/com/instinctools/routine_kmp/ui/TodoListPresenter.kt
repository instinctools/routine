package com.instinctools.routine_kmp.ui

import com.instinctools.routine_kmp.data.TodoStore
import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class TodoListPresenter(
    private val uiUpdater: (List<Todo>) -> Unit,
    private val todoStore: TodoStore
) : Presenter() {

    fun start() {
        todoStore.getTodos()
            .flowOn(Dispatchers.Default)
            .onEach { uiUpdater(it) }
            .launchIn(scope)
    }
}