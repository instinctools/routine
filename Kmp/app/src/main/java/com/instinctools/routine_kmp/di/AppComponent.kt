package com.instinctools.routine_kmp.di

import android.content.Context
import com.instinctools.routine_kmp.ui.details.TodoDetailsActivity
import com.instinctools.routine_kmp.ui.list.TodoListActivity
import com.instinctools.routine_kmp.ui.splash.SplashActivity
import dagger.BindsInstance
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component(
    modules = [
        StoreModule::class,
        PresentationModule::class,
        AuthModule::class
    ]
)
interface AppComponent {

    fun inject(activity: TodoListActivity)
    fun inject(activity: TodoDetailsActivity)
    fun inject(activity: SplashActivity)

    @Component.Factory
    interface Factory {
        fun create(@BindsInstance context: Context): AppComponent
    }
}