package com.instinctools.routine_kmp

import android.app.Application
import com.instinctools.routine_kmp.di.ComponentsProvider
import com.instinctools.routine_kmp.di.DaggerAppComponent
import kotlinx.coroutines.flow.MutableSharedFlow

class App : Application(), ComponentsProvider {

    override val appComponent by lazy {
        DaggerAppComponent.factory().create(this)
    }

    override fun onCreate() {
        super.onCreate()
        app = this
        MutableSharedFlow<>()
    }

    companion object {
        lateinit var app: App
            private set
    }
}