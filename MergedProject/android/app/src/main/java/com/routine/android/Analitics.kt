package com.routine.android

import com.google.firebase.analytics.ktx.analytics
import com.google.firebase.analytics.ktx.logEvent
import com.google.firebase.ktx.Firebase

object Analitics {

    private val firebaseAnalytics = Firebase.analytics

    fun action(action: String) {
        firebaseAnalytics.logEvent("Action") {
            param("action_type", action)
        }
    }
}