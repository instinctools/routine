package com.routine.schedulenotification

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationManager.IMPORTANCE_DEFAULT
import android.app.PendingIntent.getActivity
import android.content.Context
import android.content.Context.NOTIFICATION_SERVICE
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_CLEAR_TASK
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.os.Build.VERSION.SDK_INT
import android.os.Build.VERSION_CODES.O
import androidx.core.app.NotificationCompat
import androidx.work.Worker
import androidx.work.WorkerParameters

class ShowNotificationWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {

    companion object {
        private const val SCHEDULE_NOTIFICATION_ACTION = "android.intent.action.SCHEDULE_NOTIFICATION_ACTION"
        private const val NOTIFICATION_TITLE = "Routine"
        private const val NOTIFICATION_CHANNEL_ID = "Routine"
        private const val NOTIFICATION_CHANNEL_NAME = "Routines"
        const val KEY_MESSAGE = "KEY_MESSAGE"
    }

    override fun doWork(): Result {
        showNotification()
        return Result.success()
    }

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
            .setContentTitle(NOTIFICATION_TITLE)
            .setContentText(message)
            .setContentIntent(pendingIntent)

        if (SDK_INT >= O && notificationManager.getNotificationChannel(notificationChannelId) == null) {
            notificationManager.createNotificationChannel(NotificationChannel(NOTIFICATION_CHANNEL_ID, NOTIFICATION_CHANNEL_NAME, IMPORTANCE_DEFAULT))
        }
        notificationManager.notify(message, message.hashCode(), notification.build())
    }
}
