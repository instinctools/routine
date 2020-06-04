package com.instinctools.routine_kmp.di

import android.content.Context
import com.instinctools.routine_kmp.ui.details.TodoDetailsActivity
import com.instinctools.routine_kmp.ui.list.TodoListActivity
import dagger.BindsInstance
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component(
    modules = [
        StoreModule::class,
        PresentationModule::class
    ]
)
interface AppComponent {

    fun inject(activity: TodoListActivity)
    fun inject(activity: TodoDetailsActivity)

    @Component.Factory
    interface Factory {
        fun create(@BindsInstance context: Context): AppComponent
    }
}