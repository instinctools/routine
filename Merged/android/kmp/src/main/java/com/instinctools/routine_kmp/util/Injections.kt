package com.instinctools.routine_kmp.util

import android.content.Context
import com.instinctools.routine_kmp.di.AppComponent
import com.instinctools.routine_kmp.di.ComponentsProvider
import com.instinctools.routine_kmp.di.DaggerAppComponent

private object ComponentsProviderImpl : ComponentsProvider {

    internal var context: Context? = null

    override val appComponent: AppComponent by lazy {
        DaggerAppComponent.factory().create(context!!)
    }
}

val Context.injector: ComponentsProvider
    get() = ComponentsProviderImpl.apply {
        if (context == null) {
            context = this@injector.applicationContext
        }
    }
val Context.appComponent: AppComponent get() = injector.appComponent