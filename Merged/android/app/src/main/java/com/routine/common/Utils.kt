package com.routine.common

import android.content.Context
import android.graphics.Color
import android.view.View
import androidx.lifecycle.MutableLiveData
import androidx.work.WorkManager
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.auth.FirebaseAuth
import com.routine.data.db.entity.PeriodUnit
import com.routine.data.db.entity.ResetType
import com.routine.data.model.Event
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
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

fun calculateTimestamp(
    period: Int,
    periodUnit: PeriodUnit,
    resetType: ResetType = ResetType.BY_PERIOD,
    currentTimestamp: Date? = null
): Date {
    val dateTime = if (resetType == ResetType.BY_PERIOD || currentTimestamp == null) {
        DateTime().withTimeAtStartOfDay()
    } else {
        DateTime(currentTimestamp)
    }
    val timestamp = when (periodUnit) {
        PeriodUnit.DAY -> dateTime.plusDays(period)
        PeriodUnit.WEEK -> dateTime.plusMonths(period)
        PeriodUnit.MONTH -> dateTime.plusYears(period)
    }
    return timestamp.withTimeAtStartOfDay().toDate()
}

suspend fun <T> MutableLiveData<T>.push(data: T) {
    withContext(Dispatchers.Main) {
        yield()
        value = data
    }
}

fun showError(view: View, throwable: Throwable, block: (() -> Unit)? = null) {
    val length = if (block != null) Snackbar.LENGTH_INDEFINITE else Snackbar.LENGTH_LONG
    val snackbar = Snackbar.make(view, throwable.getErrorMessage(), length)
    if (block != null) {
        snackbar.setAction("Retry") {
            block.invoke()
        }
    }
    snackbar.show()
}

fun FirebaseAuth.userIdOrEmpty(): String = currentUser?.uid ?: ""


fun Throwable.getErrorMessage() = message ?: "An error occurred!"

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

fun addReminder(context: Context, idTag: String, message: String, targetDateLong: Long) {
    WorkManager.getInstance(context).enqueue(ShowNotificationWorker.getInstance(idTag, message, targetDateLong))
}

fun cancelReminder(context: Context, idTag: String) {
    WorkManager.getInstance(context).cancelAllWorkByTag(idTag)
}
