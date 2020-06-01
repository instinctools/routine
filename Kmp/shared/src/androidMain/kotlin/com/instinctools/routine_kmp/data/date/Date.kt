package com.instinctools.routine_kmp.data.date

import java.util.*

actual typealias TodoDate = Date

actual fun currentDate() = Date()
actual fun dateForTimestamp(timestamp: Long) = Date(timestamp)

actual operator fun Date.compareTo(anotherDate: Date) = compareTo(anotherDate)