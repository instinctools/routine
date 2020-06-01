package com.instinctools.routine_kmp.data.date

expect class TodoDate

expect fun currentDate(): TodoDate
expect fun dateForTimestamp(timestamp: Long): TodoDate

expect operator fun TodoDate.compareTo(anotherDate: TodoDate): Int