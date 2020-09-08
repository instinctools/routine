package com.routine.schedulenotification

import android.content.Context
import androidx.work.WorkManager

class ScheduleNotification(val context: Context) {
    fun addReminder(idTag: String, message: String, targetDateLong: Long) {
        WorkManager.getInstance(context).enqueue(ShowNotificationWorker.getInstance(idTag, message, targetDateLong))
    }

    fun cancelReminder(idTag: String) {
        WorkManager.getInstance(context).cancelAllWorkByTag(idTag)
    }
}
