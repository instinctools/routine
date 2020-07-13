package com.instinctools.routine_kmp.util

import android.content.Context
import com.instinctools.routine_kmp.App
import com.instinctools.routine_kmp.di.AppComponent
import com.instinctools.routine_kmp.di.ComponentsProvider

val Context.injector: ComponentsProvider get() = App.app
val Context.appComponent: AppComponent get() = injector.appComponent