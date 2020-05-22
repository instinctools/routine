package com.instinctools.routine_kmp.list

import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel

interface SwipeActionsCallback {

    fun onLeftActivated(item: TodoListUiModel)
    fun onRightActivated(item: TodoListUiModel)
}