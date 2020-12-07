package com.instinctools.routine_kmp

import android.app.Application
import com.instinctools.routine_kmp.di.ComponentsProvider
import com.instinctools.routine_kmp.di.DaggerAppComponent
import timber.log.Timber

class App : Application(), ComponentsProvider {

    override val appComponent by lazy {
        DaggerAppComponent.factory().create(this)
    }

    override fun onCreate() {
        super.onCreate()
        app = this

        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        }
    }

    companion object {
        lateinit var app: App
            private set
    }
}