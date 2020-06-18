package com.instinctools.routine_kmp.data.auth

expect class FirebaseAuthenticator {
    suspend fun getUserId(): String?
    suspend fun login(): String
    suspend fun logout()
}