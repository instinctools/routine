package com.routine.common

import android.os.Bundle
import com.google.firebase.analytics.ktx.analytics
import com.google.firebase.ktx.Firebase

object Analytics {

    private val firebaseAnalytics = Firebase.analytics

    fun action(action: String) {
        firebaseAnalytics.logEvent(action, Bundle())
    }
}
