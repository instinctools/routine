package com.routine.schedulenotification.react

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.routine.schedulenotification.ScheduleNotification
import java.util.*

const val MODULE_NAME = "NotificationHandler"

class ScheduleNotificationModule(private val scheduleNotification: ScheduleNotification, context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    @ReactMethod
    fun addReminder(idName: String, message: String, targetDate: Double) = scheduleNotification.addReminder(idName, message, targetDate.toLong())

    @ReactMethod
    fun cancelReminder(idName: String) = scheduleNotification.cancelReminder(idName)

    override fun getName(): String = MODULE_NAME
}
