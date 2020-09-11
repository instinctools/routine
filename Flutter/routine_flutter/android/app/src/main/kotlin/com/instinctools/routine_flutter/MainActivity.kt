package com.instinctools.routine_flutter

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL_REMINDER = "routine.flutter/reminder"
        private const val CHANNEL_SIDE_MENU = "routine.flutter/side_menu"
        private const val ADD_REMINDER = "addReminder"
        private const val CANCEL_REMINDER = "cancelReminder"
        private const val ON_MENU_CLICKED = "onMenuClicked"
        private const val KEY_TODO_ID = "keyTodoId"
        private const val KEY_TODO_MESSAGE = "keyTodoMessage"
        private const val KEY_TODO_TARGET_DATE = "keyTodoTargetDate"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_REMINDER).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SIDE_MENU).setMethodCallHandler { call, result ->
            when (call.method) {
                ON_MENU_CLICKED -> {
                    Log.d("MainActivity", "CHANNEL_SIDE_MENU ON_MENU_CLICKED")
//                    homeViewModel.onMenuClicked()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
