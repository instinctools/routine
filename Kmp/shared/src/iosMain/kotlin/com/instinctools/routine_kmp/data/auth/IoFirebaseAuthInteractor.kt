package com.instinctools.routine_kmp.data.auth

interface IoFirebaseAuthInteractor {
    fun getUserId(listener: (String?) -> Unit)
    fun login(listener: (String?, Exception?) -> Unit)
    fun logout(listener: (Exception?) -> Unit)
}