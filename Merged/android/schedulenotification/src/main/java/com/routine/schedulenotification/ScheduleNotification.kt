package com.routine.schedulenotification

import android.content.Context
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import org.joda.time.DateTime
import org.joda.time.Seconds
import java.util.concurrent.TimeUnit

class ScheduleNotification(private val context: Context) {

    fun addReminder(idName: String, message: String, targetDateLong: Long) {
        val targetMoment = DateTime(targetDateLong).plusHours(12)
        val timeDelay = Seconds.secondsBetween(DateTime(), targetMoment).seconds.toLong()

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
