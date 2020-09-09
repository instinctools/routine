package com.routine.schedulenotification

import android.content.Context
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import org.joda.time.DateTime
import org.joda.time.Seconds
import java.util.*
import java.util.concurrent.TimeUnit

class ScheduleNotification(val context: Context) {
    companion object {
        private const val SEVENTEEN_HOUR_IN_SECONDS = 61200
    }

    fun addReminder(idName: String, message: String, targetDateLong: Long) {
        val targetMoment = DateTime(targetDateLong + SEVENTEEN_HOUR_IN_SECONDS)
        val currentMoment = DateTime(Calendar.getInstance().time.time)
        val timeDelay = Seconds.secondsBetween(currentMoment, targetMoment).seconds.toLong()

        val oneTimeWorkRequest = OneTimeWorkRequestBuilder<ShowNotificationWorker>()
            .setInitialDelay(timeDelay, TimeUnit.SECONDS)
            .setInputData(
                Data.Builder()
                    .putString(ShowNotificationWorker.KEY_MESSAGE, message)
                    .build()
            )
            .build()

        WorkManager.getInstance(context).enqueueUniqueWork(
            idName,
            ExistingWorkPolicy.REPLACE,
            oneTimeWorkRequest
        )
    }

    fun cancelReminder(idName: String) {
        WorkManager.getInstance(context).cancelUniqueWork(idName)
    }
}
