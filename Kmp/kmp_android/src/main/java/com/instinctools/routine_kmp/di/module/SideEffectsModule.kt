package com.instinctools.routine_kmp.di.module

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.data.auth.AuthRepository
import com.instinctools.routine_kmp.domain.auth.EnsureLoginSideEffect
import com.instinctools.routine_kmp.domain.task.*
import dagger.Module
import dagger.Provides

@Module
object SideEffectsModule {

    @Provides fun provideLoginSideEffect(authRepository: AuthRepository) = EnsureLoginSideEffect(authRepository)

    @Provides fun provideGetTasksSideEffect(todoRepository: TodoRepository) = GetTasksSideEffect(todoRepository)
    @Provides fun provideGetTaskByIdSideEffect(todoRepository: TodoRepository) = GetTaskByIdSideEffect(todoRepository)
    @Provides fun provideRefreshTasksSideEffect(todoRepository: TodoRepository) = RefreshTasksSideEffect(todoRepository)

    @Provides fun provideSaveTaskSideEffect(todoRepository: TodoRepository) = SaveTaskSideEffect(todoRepository)
    @Provides fun provideResetTaskSideEffect(todoRepository: TodoRepository) = ResetTaskSideEffect(todoRepository)
    @Provides fun provideDeleteTaskSideEffect(todoRepository: TodoRepository) = DeleteTaskSideEffect(todoRepository)
}