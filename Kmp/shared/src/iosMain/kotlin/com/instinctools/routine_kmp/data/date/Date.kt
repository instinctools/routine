package com.instinctools.routine_kmp.data.date

import platform.Foundation.NSDate
import platform.Foundation.compare

actual typealias TodoDate = NSDate

actual fun dateForTimestamp(timestamp: Long) = NSDate(timestamp.toDouble())
actual fun currentDate() = NSDate()

actual operator fun TodoDate.compareTo(anotherDate: TodoDate): Int {
    return this.compare(anotherDate).toInt()
}