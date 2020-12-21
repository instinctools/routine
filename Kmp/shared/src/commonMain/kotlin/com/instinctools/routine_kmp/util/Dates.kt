package com.instinctools.routine_kmp.util

import kotlinx.datetime.*

fun currentDate(): LocalDate = Clock.System.todayAt(TimeZone.currentSystemDefault())
fun dateFromEpoch(timestamp: Long, timeZone: TimeZone = TimeZone.currentSystemDefault()) = Instant.fromEpochSeconds(timestamp).toLocalDateTime(timeZone).date
val LocalDate.timestampSystemTimeZone get() = atStartOfDayIn(TimeZone.currentSystemDefault()).epochSeconds
