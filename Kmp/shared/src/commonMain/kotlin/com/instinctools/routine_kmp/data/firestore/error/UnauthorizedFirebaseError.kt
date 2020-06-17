package com.instinctools.routine_kmp.data.firestore.error

class UnauthorizedFirebaseError : Exception("User id was empty. You should authorize current user in order to access Firestore.")