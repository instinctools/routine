package com.routine.schedulenotification

import android.content.Context
import androidx.work.WorkManager

class ScheduleNotification {
    fun addReminder(context: Context, idTag: String, message: String, targetDateLong: Long) {
        WorkManager.getInstance(context).enqueue(ShowNotificationWorker.getInstance(idTag, message, targetDateLong))
    }

    fun cancelReminder(context: Context, idTag: String) {
        WorkManager.getInstance(context).cancelAllWorkByTag(idTag)
    }
}