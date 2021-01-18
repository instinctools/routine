package com.instinctools.routine_kmp.di.module

import android.content.Context
import com.instinctools.routine_kmp.TodoDatabase
import com.instinctools.routine_kmp.data.AndroidDatabaseProvider
import com.instinctools.routine_kmp.data.LocalTodoStore
import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.data.auth.AuthRepository
import com.instinctools.routine_kmp.data.database.SqlTodoStore
import com.instinctools.routine_kmp.data.firestore.FirebaseTodoStore
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

@Module
object StoreModule {

    @Provides @Singleton
    fun provideDatabase(context: Context): TodoDatabase {
        val dbProvider = AndroidDatabaseProvider(context)
        return dbProvider.database()
    }

    @Provides @Singleton
    fun provideTodoStore(database: TodoDatabase): LocalTodoStore {
        return SqlTodoStore(database)
    }

    @Provides @Singleton
    fun provideTodoFirebaseStore() = FirebaseTodoStore()

    @Provides @Singleton
    fun provideTodoRepository(
        firebaseTodoStore: FirebaseTodoStore,
        localTodoStore: LocalTodoStore,
        authRepository: AuthRepository
    ) = TodoRepository(firebaseTodoStore, localTodoStore, authRepository)
}