package com.routine.common

import android.graphics.Color
import androidx.lifecycle.MutableLiveData
import com.google.firebase.auth.FirebaseAuth
import com.routine.R
import com.routine.data.db.entity.PeriodUnit
import com.routine.data.db.entity.ResetType
import com.routine.data.model.Event
import com.routine.data.model.ResStringWrapper
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import org.joda.time.DateTime
import org.joda.time.Days
import org.joda.time.Period
import java.util.*
import kotlin.math.roundToInt

fun getPrettyPeriod(period: Int, periodUnit: PeriodUnit): ResStringWrapper =
    when (periodUnit) {
        PeriodUnit.DAY -> ResStringWrapper(R.plurals.pretty_period_day, period, period)
        PeriodUnit.WEEK -> ResStringWrapper(R.plurals.pretty_period_week, period, period)
        PeriodUnit.MONTH -> ResStringWrapper(R.plurals.pretty_period_month, period, period)
    }

fun calculateTargetDate(date: Date): ResStringWrapper {
    val targetDate = DateTime(date).withTimeAtStartOfDay()
    val currentDate = DateTime().withTimeAtStartOfDay()

    val period = Period(currentDate, targetDate)
    val diffDays = Days.daysBetween(currentDate, targetDate).days

    return when {
        diffDays == 0 -> ResStringWrapper(R.string.target_date_today, null, 0)
        diffDays == 1 -> ResStringWrapper(R.string.target_date_tomorrow, null, 0)
        diffDays == 7 -> ResStringWrapper(R.string.target_date_week, null, 0)
        diffDays in 2..6 -> ResStringWrapper(R.string.target_date_days, diffDays, 0)
        diffDays == -1 -> ResStringWrapper(R.string.target_date_yesterday, null, 0)
        diffDays < -1 -> {
            val (resId, quantity) = when {
                period.years < 0 -> Pair(R.plurals.target_date_last_years, Math.abs(period.years))
                period.months < 0 -> Pair(R.plurals.target_date_last_months, Math.abs(period.months))
                period.weeks < 0 -> Pair(R.plurals.target_date_last_weeks, Math.abs(period.weeks))
                else -> Pair(R.plurals.target_date_last_days, Math.abs(period.days))
            }
            ResStringWrapper(resId, quantity, quantity)
        }
        else -> ResStringWrapper(R.string.target_date_empty, null, 0)
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

fun calculateTimestamp(
    period: Int,
    periodUnit: PeriodUnit,
    resetType: ResetType = ResetType.BY_PERIOD,
    currentTimestamp: Date? = null
): Date {
    val dateTime = if (resetType == ResetType.BY_PERIOD || currentTimestamp == null || DateTime(currentTimestamp).isBefore(DateTime().withTimeAtStartOfDay())) {
        DateTime()
    } else {
        DateTime(currentTimestamp)
    }
    val timestamp = when (periodUnit) {
        PeriodUnit.DAY -> dateTime.plusDays(period)
        PeriodUnit.WEEK -> dateTime.plusWeeks(period)
        PeriodUnit.MONTH -> dateTime.plusMonths(period)
    }
    return timestamp.withTimeAtStartOfDay().toDate()
}

suspend fun <T> MutableLiveData<T>.push(data: T) {
    withContext(Dispatchers.Main) {
        yield()
        value = data
    }
}

fun FirebaseAuth.userIdOrEmpty(): String = currentUser?.uid ?: ""

fun <T> Flow<T>.throttleFirst(periodMillis: Long): Flow<T> {
    require(periodMillis > 0) { "period should be positive" }
    return flow {
        var lastTime = 0L
        collect { value ->
            val currentTime = System.currentTimeMillis()
            if (currentTime - lastTime >= periodMillis) {
                lastTime = currentTime
                emit(value)
            }
        }
    }
}

@ExperimentalCoroutinesApi
fun <T> Flow<T>.launchIn(coroutineScope: CoroutineScope, stateFlow: MutableStateFlow<Event<T>?>) {
    map { Event(it) }.onEach {
        stateFlow.value = it
    }.launchIn(coroutineScope)
}
