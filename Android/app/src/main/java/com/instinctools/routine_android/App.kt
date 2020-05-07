package com.instinctools.routine_android

import android.app.Application
import android.content.Context

class App : Application() {

    companion object {
        lateinit var CONTEXT: Context
    }

    override fun onCreate() {
        super.onCreate()
        CONTEXT = this
    }
}