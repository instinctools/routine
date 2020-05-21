package com.instinctools.routine_kmp.list

import com.instinctools.routine_kmp.ui.todo.TodoUiModel

interface SwipeActionsCallback {

    fun onLeftActivated(item: TodoUiModel)
    fun onRightActivated(item: TodoUiModel)
}