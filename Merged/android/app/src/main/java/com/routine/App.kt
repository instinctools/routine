package com.routine

import android.app.Application
import android.content.Context
import timber.log.Timber

class App : Application() {

    companion object {
        @JvmStatic
        lateinit var CONTEXT: Context
    }

    override fun onCreate() {
        super.onCreate()
        CONTEXT = this
        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        }
    }
}
