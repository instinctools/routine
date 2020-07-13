@file:SuppressLint("NewApi")

package com.instinctools.routine_kmp.data.date

import android.annotation.SuppressLint
import com.instinctools.routine_kmp.model.PeriodUnit
import java.time.*
import java.util.concurrent.TimeUnit

actual typealias TodoDate = LocalDate

actual fun currentDate(): LocalDate = LocalDate.now()
actual fun dateForTimestamp(timestamp: Long): LocalDate = LocalDateTime.ofInstant(Instant.ofEpochMilli(timestamp), ZoneId.systemDefault()).toLocalDate()

actual operator fun LocalDate.compareTo(anotherDate: LocalDate) = compareTo(anotherDate)
actual val TodoDate.timestamp: Long
    get() {
        val localDateTime = atStartOfDay(ZoneId.systemDefault())
        return localDateTime.toInstant().toEpochMilli()
    }

actual fun TodoDate.plus(unit: PeriodUnit, count: Int): TodoDate {
    val countLong = count.toLong()
    return when (unit) {
        PeriodUnit.DAY -> plusDays(countLong)
        PeriodUnit.WEEK -> plusWeeks(countLong)
        PeriodUnit.MONTH -> plusMonths(countLong)
        PeriodUnit.YEAR -> plusYears(countLong)
    }
}

actual fun daysBetween(date1: TodoDate, date2: TodoDate): Int {
    return Duration.between(date1.atStartOfDay(), date2.atStartOfDay()).toDays().toInt()
}