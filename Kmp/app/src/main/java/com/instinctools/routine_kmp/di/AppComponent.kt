package com.instinctools.routine_kmp.di

import android.content.Context
import com.instinctools.routine_kmp.di.module.AuthModule
import com.instinctools.routine_kmp.di.module.PresentationModule
import com.instinctools.routine_kmp.di.module.SideEffectsModule
import com.instinctools.routine_kmp.di.module.StoreModule
import com.instinctools.routine_kmp.ui.SplashPresenter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenterFactory
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter
import dagger.BindsInstance
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component(
    modules = [
        StoreModule::class,
        PresentationModule::class,
        AuthModule::class,
        SideEffectsModule::class
    ]
)
interface AppComponent {

    val splashPresenter: SplashPresenter
    val todoListPresenter: TodoListPresenter
    val todoDetailsPresenterFactory: TodoDetailsPresenterFactory

    @Component.Factory
    interface Factory {
        fun create(@BindsInstance context: Context): AppComponent
    }
}