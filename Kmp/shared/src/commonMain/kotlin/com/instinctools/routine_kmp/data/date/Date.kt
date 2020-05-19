package com.instinctools.routine_kmp.data.date

expect class MyDate

expect fun currentDate(): MyDate
expect fun dateForTimestamp(timestamp: Long): MyDate

expect operator fun MyDate.compareTo(anotherDate: MyDate): Int