package com.routine.schedulenotification.react

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.routine.schedulenotification.ScheduleNotification

const val MODULE_NAME = "NotificationHandler"

class ScheduleNotificationModule(private val scheduleNotification: ScheduleNotification, context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    @ReactMethod
    fun addReminder(idTag: String, message: String, targetDateLong: Long) = scheduleNotification.addReminder(idTag, message, targetDateLong)

    @ReactMethod
    fun cancelReminder(idTag: String) = scheduleNotification.cancelReminder(idTag)

    override fun getName(): String = MODULE_NAME
}
