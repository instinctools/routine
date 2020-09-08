package com.instinctools.routine_flutter

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "routine.flutter/reminder"
    private val ADD_REMINDER = "addReminder"
    private val CANCEL_REMINDER = "cancelReminder"
    private val KEY_TODO_ID = "keyTodoId"
    private val KEY_TODO_MESSAGE = "keyTodoMessage"
    private val KEY_TODO_TARGET_DATE = "keyTodoTargetDate"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            when (call.method) {
                ADD_REMINDER -> {
                    Log.d("mainActivity", "ADD_REMINDER call.arguments = ${call.arguments}");
                    val id = call.argument<String>(KEY_TODO_ID)
                    val message = call.argument<String>(KEY_TODO_MESSAGE)
                    val targetDate = call.argument<Long>(KEY_TODO_TARGET_DATE)
                    //addReminder(id, message, targetDate)
                }
                CANCEL_REMINDER -> {
                    Log.d("mainActivity", "CANCEL_REMINDER call.arguments = ${call.arguments}");
                    val id = call.argument<String>(KEY_TODO_ID)
                    //cancelReminder()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
