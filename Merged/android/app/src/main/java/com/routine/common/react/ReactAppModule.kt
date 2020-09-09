package com.routine.common.react

import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import java.lang.ref.WeakReference

object ReactAppModule : ReactContextBaseJavaModule() {

    override fun getName(): String = "NativeAppModule"

    var menuClickListener: WeakReference<() -> Unit>? = null

    @ReactMethod
    fun onMenuClicked() {
        menuClickListener?.get()?.invoke()
    }
}
