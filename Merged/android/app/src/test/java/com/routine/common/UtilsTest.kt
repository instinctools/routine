package com.routine.common

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.routine.R
import com.routine.data.db.entity.PeriodUnit
import com.routine.data.db.entity.ResetType
import org.joda.time.DateTime
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import java.util.*

@RunWith(AndroidJUnit4::class)
class UtilsTest {

    @Test
    fun prettyPeriod_day() {
        val period = Random().nextInt()
        val result = getPrettyPeriod(period, PeriodUnit.DAY)
        assertEquals(result.resId, R.plurals.pretty_period_day)
        assertEquals(result.args, period)
        assertEquals(result.quantity, period)
    }

    @Test
    fun prettyPeriod_week() {
        val period = Random().nextInt()
        val result = getPrettyPeriod(period, PeriodUnit.WEEK)
        assertEquals(result.resId, R.plurals.pretty_period_week)
        assertEquals(result.args, period)
        assertEquals(result.quantity, period)
    }

    @Test
    fun prettyPeriod_month() {
        val period = Random().nextInt()
        val result = getPrettyPeriod(period, PeriodUnit.MONTH)
        assertEquals(result.resId, R.plurals.pretty_period_month)
        assertEquals(result.args, period)
        assertEquals(result.quantity, period)
    }

    @Test
    fun calculateTargetDate_today() {
        val result = calculateTargetDate(Date())
        assertEquals(result.resId, R.string.target_date_today)
        assertEquals(result.args, null)
        assertEquals(result.quantity, 0)
    }

    @Test
    fun calculateTargetDate_tommorow() {
        val dateTime = DateTime().plusDays(1)
        val result = calculateTargetDate(dateTime.toDate())
        assertEquals(result.resId, R.string.target_date_tomorrow)
        assertEquals(result.args, null)
        assertEquals(result.quantity, 0)
    }

    @Test
    fun calculateTargetDate_1_week_left() {
        val dateTime = DateTime().plusDays(7)
        val result = calculateTargetDate(dateTime.toDate())
        assertEquals(result.resId, R.string.target_date_week)
        assertEquals(result.args, null)
        assertEquals(result.quantity, 0)
    }

    @Test
    fun calculateTargetDate_days_left() {
        val dateTime = DateTime()
        for (i in 2..6) {
            val result = calculateTargetDate(dateTime.plusDays(i).toDate())
            assertEquals(result.resId, R.string.target_date_days)
            assertEquals(result.args, i)
            assertEquals(result.quantity, 0)
        }
    }

    @Test
    fun calculateTargetDate_yesterday() {
        val dateTime = DateTime().minusDays(1)
        val result = calculateTargetDate(dateTime.toDate())
        assertEquals(result.resId, R.string.target_date_yesterday)
        assertEquals(result.args, null)
        assertEquals(result.quantity, 0)
    }

    @Test
    fun calculateTargetDate_lastYears() {
        val dateTime = DateTime()
        for (i in 1..5) {
            val result = calculateTargetDate(dateTime.minusYears(i).toDate())
            assertEquals(result.resId, R.plurals.target_date_last_years)
            assertEquals(result.args, i)
            assertEquals(result.quantity, i)
        }
    }

    @Test
    fun calculateTargetDate_lastMonths() {
        val dateTime = DateTime()
        for (i in 1..11) {
            val result = calculateTargetDate(dateTime.minusMonths(i).toDate())
            assertEquals(result.resId, R.plurals.target_date_last_months)
            assertEquals(result.args, i)
            assertEquals(result.quantity, i)
        }
    }

    @Test
    fun calculateTargetDate_lastWeeks() {
        val dateTime = DateTime()
        for (i in 1..4) {
            val result = calculateTargetDate(dateTime.minusWeeks(i).toDate())
            assertEquals(result.resId, R.plurals.target_date_last_weeks)
            assertEquals(result.args, i)
            assertEquals(result.quantity, i)
        }
    }

    @Test
    fun calculateTargetDate_lastDays() {
        val dateTime = DateTime()
        for (i in 2..6) {
            val result = calculateTargetDate(dateTime.minusDays(i).toDate())
            assertEquals(result.resId, R.plurals.target_date_last_days)
            assertEquals(result.args, i)
            assertEquals(result.quantity, i)
        }
    }

    @Test
    fun pickColorBetween() {
        val colors = intArrayOf(
            -50889, -48584, -46279, -43975, -41926, -39621, -37316, -35011, -32707,
            -30402, -28097, -25792, -23743, -21439, -19134, -16829, -16829, -16829, -16829, -16829
        )
        for (i in 0..19) {
            val color = pickColorBetween(i)
            assertEquals(color, colors[i])
        }
    }

    @Test
    fun calculateTimestamp_period_create() {
        calculateTimestamp_validate_period_5_days(ResetType.BY_PERIOD, null)
    }

    @Test
    fun calculateTimestamp_date_create() {
        calculateTimestamp_validate_period_5_days(ResetType.BY_DATE, null)
    }

    @Test
    fun calculateTimestamp_period_reset() {
        calculateTimestamp_validate_period_5_days(ResetType.BY_PERIOD, DateTime().plusDays(5).toDate())
    }

    @Test
    fun calculateTimestamp_period_expired_reset() {
        calculateTimestamp_validate_period_5_days(ResetType.BY_PERIOD, DateTime().minusDays(5).toDate())
    }

    @Test
    //Skip reset date because Timestamp - period < currentDate
    fun calculateTimestamp_date_not_reset() {
        val period = 5
        for (periodUnit in PeriodUnit.values()) {
            val date = DateTime()
            val timestamp = when (periodUnit) {
                PeriodUnit.DAY -> date.plusDays(8)
                PeriodUnit.WEEK -> date.plusWeeks(8)
                PeriodUnit.MONTH -> date.plusMonths(8)
            }
            val result = calculateTimestamp(period, periodUnit, ResetType.BY_DATE, timestamp.toDate())
            assertEquals(timestamp, DateTime(result))
        }
    }

    @Test
    //Reset date if Timestamp - period > currentDate
    fun calculateTimestamp_date_reset_once() {
        val period = 5
        for (periodUnit in PeriodUnit.values()) {
            val date = DateTime()
            val timestamp = when (periodUnit) {
                PeriodUnit.DAY -> date.plusDays(3)
                PeriodUnit.WEEK -> date.plusWeeks(3)
                PeriodUnit.MONTH -> date.plusMonths(3)
            }

            val newDate = DateTime(timestamp)
            val newTimestamp = when (periodUnit) {
                PeriodUnit.DAY -> newDate.plusDays(period)
                PeriodUnit.WEEK -> newDate.plusWeeks(period)
                PeriodUnit.MONTH -> newDate.plusMonths(period)
            }.withTimeAtStartOfDay()

            val result = calculateTimestamp(period, periodUnit, ResetType.BY_DATE, timestamp.toDate())
            assertEquals(newTimestamp, DateTime(result))
        }
    }

    @Test
    fun calculateTimestamp_date_expired_reset() {
        calculateTimestamp_validate_period_5_days(ResetType.BY_DATE, DateTime().minusDays(3).toDate())
    }


    fun calculateTimestamp_validate_period_5_days(resetType: ResetType, time: Date?){
        val period = 5
        for (periodUnit in PeriodUnit.values()) {
            val date = DateTime()
            val newTimestamp = when (periodUnit) {
                PeriodUnit.DAY -> date.plusDays(period)
                PeriodUnit.WEEK -> date.plusWeeks(period)
                PeriodUnit.MONTH -> date.plusMonths(period)
            }.withTimeAtStartOfDay()

            val result = calculateTimestamp(period, periodUnit, resetType, time)
            assertEquals(newTimestamp, DateTime(result))
        }
    }
}
