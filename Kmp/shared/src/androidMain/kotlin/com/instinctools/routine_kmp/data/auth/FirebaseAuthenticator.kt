package com.instinctools.routine_kmp.data.auth

import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.instinctools.routine_kmp.data.firestore.error.UnauthorizedFirebaseError
import kotlinx.coroutines.tasks.await

actual class FirebaseAuthenticator {

    actual suspend fun getUserId(): String? {
        return Firebase.auth.currentUser?.uid
    }

    actual suspend fun login(): String {
        var user = Firebase.auth.currentUser
        if (user == null) {
            val authResult = Firebase.auth.signInAnonymously().await()
            user = authResult.user ?: throw UnauthorizedFirebaseError()
        }
        return user.uid
    }

    actual suspend fun logout() {
        Firebase.auth.signOut()
    }
}