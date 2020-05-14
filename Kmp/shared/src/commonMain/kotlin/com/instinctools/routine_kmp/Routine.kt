package com.instinctools.routine_kmp

expect fun platformName(): String

fun friendlyMessage() = "Hello ${platformName()} user"