package com.instinctools.routine_kmp.di.module

import com.instinctools.routine_kmp.domain.auth.EnsureLoginSideEffect
import com.instinctools.routine_kmp.domain.task.*
import com.instinctools.routine_kmp.ui.SplashPresenter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenterFactory
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter
import dagger.Module
import dagger.Provides

@Module
object PresentationModule {

    @Provides
    fun provideTodoListPresenter(
        getTasksSideEffect: GetTasksSideEffect,
        deleteTaskSideEffect: DeleteTaskSideEffect,
        resetTaskSideEffect: ResetTaskSideEffect,
        refreshTasksSideEffect: RefreshTasksSideEffect,
    ) = TodoListPresenter(getTasksSideEffect, deleteTaskSideEffect, resetTaskSideEffect, refreshTasksSideEffect)

    @Provides
    fun provideTodoDetailsFactory(
        getTaskByIdSideEffect: GetTaskByIdSideEffect,
        saveTaskSideEffect: SaveTaskSideEffect
    ) = TodoDetailsPresenterFactory(getTaskByIdSideEffect, saveTaskSideEffect)

    @Provides
    fun provideSplashPresent(
        ensureLoginSideEffect: EnsureLoginSideEffect
    ) = SplashPresenter(ensureLoginSideEffect)
}