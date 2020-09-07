package com.routine.notification

import android.widget.Toast
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod


class NotificationModule(context: ReactApplicationContext): ReactContextBaseJavaModule(context) {
    override fun getName(): String = "NotificationHandler"

    @ReactMethod
    fun show(message: String, duration: Int) {
        Toast.makeText(reactApplicationContext, message, duration).show()
    }
}
