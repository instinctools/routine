package com.instinctools.routine_kmp.util

import kotlinx.datetime.*

fun currentDate(): LocalDate = Clock.System.todayAt(TimeZone.currentSystemDefault())
fun dateFromEpoch(timestamp: Long) = Instant.fromEpochSeconds(timestamp).toLocalDateTime(TimeZone.currentSystemDefault()).date
val LocalDate.timestampSystemTimeZone get() = atStartOfDayIn(TimeZone.currentSystemDefault()).epochSeconds
