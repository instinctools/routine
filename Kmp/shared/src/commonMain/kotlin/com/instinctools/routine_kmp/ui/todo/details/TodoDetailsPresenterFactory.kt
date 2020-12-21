package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.domain.task.GetTaskByIdSideEffect
import com.instinctools.routine_kmp.domain.task.SaveTaskSideEffect

class TodoDetailsPresenterFactory(
    private val getTaskByIdSideEffect: GetTaskByIdSideEffect,
    private val saveTaskSideEffect: SaveTaskSideEffect
) {
    fun create(todoId: String?) = TodoDetailsPresenter(todoId, getTaskByIdSideEffect, saveTaskSideEffect)
}