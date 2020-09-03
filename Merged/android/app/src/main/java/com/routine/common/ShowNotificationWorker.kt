package com.routine.common

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationManager.IMPORTANCE_HIGH
import android.app.PendingIntent.getActivity
import android.content.Context
import android.content.Context.NOTIFICATION_SERVICE
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_CLEAR_TASK
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.graphics.Color.RED
import android.media.AudioAttributes
import android.media.AudioAttributes.CONTENT_TYPE_SONIFICATION
import android.media.AudioAttributes.USAGE_NOTIFICATION_RINGTONE
import android.media.RingtoneManager.TYPE_NOTIFICATION
import android.media.RingtoneManager.getDefaultUri
import android.os.Build.VERSION.SDK_INT
import android.os.Build.VERSION_CODES.O
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.DEFAULT_ALL
import androidx.core.app.NotificationCompat.PRIORITY_MAX
import androidx.work.OneTimeWorkRequest
import androidx.work.Worker
import androidx.work.WorkerParameters
import com.routine.R
import com.routine.common.home.ActivityHome
import kotlinx.coroutines.ExperimentalCoroutinesApi
import java.util.concurrent.TimeUnit

class ShowNotificationWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {

    companion object {
        private lateinit var message: String
        private var timeDelay: Long = 0
        const val NOTIFICATION_NAME = "reminder"

        fun getInstance(message: String, timeDelay: Long): OneTimeWorkRequest {
            ShowNotificationWorker.message = message
            ShowNotificationWorker.timeDelay = timeDelay
            return OneTimeWorkRequest.Builder(ShowNotificationWorker::class.java)
                .addTag(message)
                .setInitialDelay(timeDelay, TimeUnit.SECONDS)
                .build()
        }
    }

    @ExperimentalCoroutinesApi
    override fun doWork(): Result {
        showNotification()
        return Result.success()
    }

    @ExperimentalCoroutinesApi
    private fun showNotification() {
        val intent = Intent(applicationContext, ActivityHome::class.java).apply {
            flags = FLAG_ACTIVITY_NEW_TASK or FLAG_ACTIVITY_CLEAR_TASK
        }

        val notificationManager = applicationContext.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        val notificationChannel = applicationContext.resources.getString(R.string.app_name)

        val pendingIntent = getActivity(applicationContext, 0, intent, 0)
        val notification = NotificationCompat
            .Builder(applicationContext, notificationChannel)
            .setSmallIcon(R.drawable.ic_launcher)
            .setContentTitle(message)
            .setDefaults(DEFAULT_ALL)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setPriority(PRIORITY_MAX)

        if (SDK_INT >= O) {
            notification.setChannelId(notificationChannel)
            val ringtoneManager = getDefaultUri(TYPE_NOTIFICATION)
            val audioAttributes = AudioAttributes.Builder()
                .setUsage(USAGE_NOTIFICATION_RINGTONE)
                .setContentType(CONTENT_TYPE_SONIFICATION)
                .build()
            val channel = NotificationChannel(
                applicationContext.resources.getString(R.string.app_name),
                NOTIFICATION_NAME,
                IMPORTANCE_HIGH
            ).apply {
                enableLights(true)
                lightColor = RED
                enableVibration(true)
                vibrationPattern = longArrayOf(100, 200, 300, 400, 500, 400, 300, 200, 400)
                setSound(ringtoneManager, audioAttributes)
            }
            notificationManager.createNotificationChannel(channel)
        }
        notificationManager.notify(message, message.hashCode(), notification.build())
    }
}