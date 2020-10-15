package com.routine.di

import com.routine.common.data.datasotre.SettingsDataStore
import com.routine.common.data.repo.SettingsRepository
import com.routine.common.data.repo.SettingsRepositoryImpl
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

    @Binds
    @Singleton
    abstract fun bindSettingsRepository(settingsRepositoryImpl: SettingsRepositoryImpl): SettingsRepository
}
