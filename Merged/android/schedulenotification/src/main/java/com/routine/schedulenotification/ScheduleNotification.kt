package com.routine.schedulenotification

import androidx.work.WorkManager
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

const val MODULE_NAME = "NotificationHandler"

class ScheduleNotification(private val context: ReactApplicationContext) :
    ReactContextBaseJavaModule(context) {

    @ReactMethod
    fun addReminder(idTag: String, message: String, targetDateLong: Long) {
        WorkManager.getInstance(context)
            .enqueue(ShowNotificationWorker.getInstance(idTag, message, targetDateLong))
    }

    @ReactMethod
    fun cancelReminder(idTag: String) {
        WorkManager.getInstance(context).cancelAllWorkByTag(idTag)
    }

    override fun getName(): String = MODULE_NAME
}
