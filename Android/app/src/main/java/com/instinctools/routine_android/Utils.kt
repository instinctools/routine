package com.instinctools.routine_android

import android.graphics.Color
import com.instinctools.routine_android.data.db.entity.PeriodUnit
import org.joda.time.DateTime
import org.joda.time.Days
import org.joda.time.Period
import java.util.*
import kotlin.math.roundToInt

fun prettyPeriod(period: Int, periodUnit: PeriodUnit): String {
    return if (period == 1) {
        when (periodUnit) {
            PeriodUnit.DAY -> "Every day"
            PeriodUnit.WEEK -> "Once a week"
            PeriodUnit.MONTH -> "Once a month"
        }
    } else {
        "Every $period ${periodUnit.name.toLowerCase()}"
    }
}

fun calculateTargetDate(date: Date): String {
    val targetDate = DateTime(date)
    val currentDate = DateTime().withTimeAtStartOfDay()

    val diffDays = Days.daysBetween(currentDate, targetDate).days


    return when {
        diffDays == 0 -> "Today"
        diffDays == 1 -> "Tomorrow"
        diffDays == 7 -> "1 week left"
        diffDays in 2..6 -> "$diffDays days left"
        diffDays == -1 -> "Yesterday"
        diffDays < -1 -> {
            val period = Period(targetDate, currentDate)
            return when {
                period.years > 0 -> {
                    "${period.years} years ago"
                }
                period.months > 0 -> {
                    "${period.months} months ago"
                }
                period.weeks > 0 -> {
                    "${period.weeks} weeks ago"
                }
                period.days > 0 -> {
                    "${period.days} days ago"
                }
                else -> ""
            }
        }
        else -> ""
    }
}

fun pickColorBetween(index: Int, maxIndex: Int = 15, color1: IntArray = intArrayOf(255, 190, 67), color2: IntArray = intArrayOf(255, 57, 55)): Int {
    var w1 = 1f
    if (index < maxIndex) {
        w1 = index.toFloat() / maxIndex
    }
    val w2 = 1 - w1
    val colorRGB = intArrayOf(
            (color1[0] * w1 + color2[0] * w2).roundToInt(),
            (color1[1] * w1 + color2[1] * w2).roundToInt(),
            (color1[2] * w1 + color2[2] * w2).roundToInt())
    return Color.argb(255, colorRGB[0], colorRGB[1], colorRGB[2])
}

fun calculateTimestamp(period: Int, periodUnit: PeriodUnit): Date {
    val dateTime = DateTime().withTimeAtStartOfDay()
    val timestamp = when (periodUnit) {
        PeriodUnit.DAY -> dateTime.plusDays(period)
        PeriodUnit.WEEK -> dateTime.plusMonths(period)
        PeriodUnit.MONTH -> dateTime.plusYears(period)
    }
    return timestamp.withTimeAtStartOfDay().toDate()
}