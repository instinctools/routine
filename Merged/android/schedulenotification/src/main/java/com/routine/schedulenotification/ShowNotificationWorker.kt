package com.routine.schedulenotification

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
import androidx.work.Worker
import androidx.work.WorkerParameters
import kotlinx.coroutines.ExperimentalCoroutinesApi


class ShowNotificationWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {

    companion object {
        private const val SCHEDULE_NOTIFICATION_ACTION = "android.intent.action.SCHEDULE_NOTIFICATION_ACTION"
        private const val NOTIFICATION_CHANNEL_ID = "Routine"
        private const val NOTIFICATION_CHANNEL_NAME = "Routines"
        const val KEY_MESSAGE = "KEY_MESSAGE"
    }

    @ExperimentalCoroutinesApi
    override fun doWork(): Result {
        showNotification()
        return Result.success()
    }

    @ExperimentalCoroutinesApi
    private fun showNotification() {
        val message = inputData.getString(KEY_MESSAGE)
        val notificationManager = applicationContext.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        val notificationChannelId = NOTIFICATION_CHANNEL_ID

        val intent = Intent(SCHEDULE_NOTIFICATION_ACTION).apply {
            flags = FLAG_ACTIVITY_NEW_TASK or FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = getActivity(applicationContext, 0, intent, 0)
        val notification = NotificationCompat
            .Builder(applicationContext, notificationChannelId)
            .setSmallIcon(R.drawable.ic_logo_splash_screen)
            .setContentTitle(message)
            .setDefaults(DEFAULT_ALL)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setPriority(PRIORITY_MAX)

        if (SDK_INT >= O) {
            notification.setChannelId(notificationChannelId)
            val ringtoneManager = getDefaultUri(TYPE_NOTIFICATION)
            val audioAttributes = AudioAttributes.Builder()
                .setUsage(USAGE_NOTIFICATION_RINGTONE)
                .setContentType(CONTENT_TYPE_SONIFICATION)
                .build()
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                NOTIFICATION_CHANNEL_NAME,
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