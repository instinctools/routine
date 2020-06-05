package com.instinctools.routine_kmp.data.date

import com.instinctools.routine_kmp.model.PeriodUnit

expect class TodoDate

expect fun currentDate(): TodoDate
expect fun dateForTimestamp(timestamp: Long): TodoDate

expect operator fun TodoDate.compareTo(anotherDate: TodoDate): Int
expect val TodoDate.timestamp: Long

expect fun TodoDate.plus(unit: PeriodUnit, count: Int): TodoDate
expect fun daysBetween(date1: TodoDate, date2: TodoDate): Int