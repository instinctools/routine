package com.routine.flutter

import androidx.annotation.NonNull
import com.routine.App
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import timber.log.Timber

class FlutterAppFragment : FlutterFragment() {

    companion object {
        private const val CHANNEL = "routine.flutter/reminder"
        private const val ADD_REMINDER = "addReminder"
        private const val CANCEL_REMINDER = "cancelReminder"
        private const val KEY_TODO_ID = "keyTodoId"
        private const val KEY_TODO_MESSAGE = "keyTodoMessage"
        private const val KEY_TODO_TARGET_DATE = "keyTodoTargetDate"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Companion.CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            when (call.method) {
                ADD_REMINDER -> {
                    Timber.d("ADD_REMINDER call.arguments = ${call.arguments}")
                    val idName = call.argument<String>(KEY_TODO_ID)
                    val message = call.argument<String>(KEY_TODO_MESSAGE)
                    val targetDate = call.argument<Long>(KEY_TODO_TARGET_DATE)
                    if (idName != null && message != null && targetDate != null) {
                        App.scheduleNotification.addReminder(idName, message, targetDate)
                    } else {
                        throw Exception("ADD_REMINDER call.arguments some argument == null")
                    }
                    //addReminder(idName, message, targetDate)
                }
                CANCEL_REMINDER -> {
                    Timber.d("CANCEL_REMINDER call.arguments = ${call.arguments}")
                    when (val idName = call.argument<String>(KEY_TODO_ID)) {
                        null -> throw Exception("call.argument<String>(KEY_TODO_ID) => idName == null")
                        else -> App.scheduleNotification.cancelReminder(idName)
                    }
                    //cancelReminder()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}