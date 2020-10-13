package com.routine.di

import com.routine.data.repo.TodosRepository
import com.routine.data.repo.TodosRepositoryImpl
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ApplicationComponent
import javax.inject.Singleton

@Module
@InstallIn(ApplicationComponent::class)
abstract class RepositoryModule {

    @Binds
    @Singleton
    abstract fun bindTodosRepository(todosRepository: TodosRepositoryImpl): TodosRepository
}