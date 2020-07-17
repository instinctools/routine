package com.routine

import android.content.Context
import com.routine.react.ReactApplication
import timber.log.Timber

class App : ReactApplication() {

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
