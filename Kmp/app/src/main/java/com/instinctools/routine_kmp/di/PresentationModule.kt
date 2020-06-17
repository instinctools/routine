package com.instinctools.routine_kmp.di

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenterFactory
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter
import dagger.Module
import dagger.Provides

@Module
object PresentationModule {

    @Provides
    fun provideTodoListPresenter(todoRepository: TodoRepository) = TodoListPresenter(todoRepository)

    @Provides
    fun provideTodoDetailsFactory(
        todoRepository: TodoRepository
    ) = TodoDetailsPresenterFactory(todoRepository)
}