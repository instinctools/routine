package com.instinctools.routine_kmp.util

import kotlinx.datetime.Clock
import kotlinx.datetime.LocalDate
import kotlinx.datetime.TimeZone
import kotlinx.datetime.todayAt

fun currentDate(): LocalDate = Clock.System.todayAt(TimeZone.currentSystemDefault())
