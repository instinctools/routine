package com.instinctools.routine_kmp.di

import com.instinctools.routine_kmp.data.TodoStore
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenterFactory
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter
import dagger.Module
import dagger.Provides

@Module
object PresentationModule {

    @Provides
    fun provideTodoListPresenter(todoStore: TodoStore) = TodoListPresenter(todoStore)

    @Provides
    fun provideTodoDetailsFactory(
        todoStore: TodoStore
    ) = TodoDetailsPresenterFactory(todoStore)
}