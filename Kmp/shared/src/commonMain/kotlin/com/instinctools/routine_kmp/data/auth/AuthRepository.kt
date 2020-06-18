package com.instinctools.routine_kmp.data.auth

import com.instinctools.routine_kmp.data.firestore.error.UnauthorizedFirebaseError

class AuthRepository(
    private val firebaseAuthenticator: FirebaseAuthenticator
) {

    suspend fun requireUserId(): String {
        return getUserId() ?: throw UnauthorizedFirebaseError()
    }

    suspend fun getUserId(): String? {
        return firebaseAuthenticator.getUserId()
    }

    suspend fun loginAnonymously() {
        firebaseAuthenticator.login()
    }

    suspend fun logout() {
        firebaseAuthenticator.logout()
    }
}