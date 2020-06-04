package com.instinctools.routine_kmp.data.date

import com.instinctools.routine_kmp.model.PeriodUnit
import platform.Foundation.NSDate
import platform.Foundation.compare
import platform.Foundation.timeIntervalSince1970

actual typealias TodoDate = NSDate

actual fun dateForTimestamp(timestamp: Long) = NSDate(timestamp.toDouble())
actual fun currentDate() = NSDate()

actual operator fun TodoDate.compareTo(anotherDate: TodoDate): Int {
    return this.compare(anotherDate).toInt()
}

actual val TodoDate.timestamp: Long
    get() = timeIntervalSince1970.toLong()

actual fun TodoDate.plus(unit: PeriodUnit, count: Int): TodoDate {
    TODO("Not yet implemented")
}