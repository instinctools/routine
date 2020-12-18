package com.instinctools.routine_kmp.util

import com.instinctools.routine_kmp.model.PeriodUnit

fun PeriodUnit.title(count: Int = 0): String {
    val hasPeriod = count > 1
    val printCount = if (count <= 1) "" else count.toString()
    val periodEnding = when (this) {
        PeriodUnit.DAY -> if (hasPeriod) "Days" else "Day"
        PeriodUnit.WEEK -> if (hasPeriod) "Weeks" else "Week"
        PeriodUnit.MONTH -> if (hasPeriod) "Months" else "Month"
        PeriodUnit.YEAR -> if (hasPeriod) "Years" else "Year"
    }
    return "$printCount $periodEnding"
}