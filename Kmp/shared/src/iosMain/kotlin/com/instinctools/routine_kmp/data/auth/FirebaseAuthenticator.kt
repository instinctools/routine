package com.instinctools.routine_kmp.data.auth

import com.instinctools.routine_kmp.data.firestore.error.UnauthorizedFirebaseError
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

actual class FirebaseAuthenticator(
    private val interactor: IoFirebaseAuthInteractor
) {

    actual suspend fun getUserId(): String? {
        return suspendCancellableCoroutine { continuation ->
            interactor.getUserId { userId ->
                continuation.resume(userId)
            }
        }
    }

    actual suspend fun login(): String {
        return suspendCancellableCoroutine { continuation ->
            interactor.login { userId, exception ->
                if (exception != null) {
                    continuation.resumeWithException(exception)
                } else {
                    userId ?: throw UnauthorizedFirebaseError()
                    continuation.resume(userId)
                }
            }
        }
    }

    actual suspend fun logout() {
        return suspendCancellableCoroutine { continuation ->
            interactor.logout { exception ->
                if (exception != null) {
                    continuation.resumeWithException(exception)
                } else {
                    continuation.resume(Unit)
                }
            }
        }
    }
}