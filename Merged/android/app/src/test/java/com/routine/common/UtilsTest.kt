package com.routine.common

import com.routine.R
import com.routine.data.db.entity.PeriodUnit
import org.joda.time.DateTime
import org.junit.Assert.assertEquals
import org.junit.Test
import java.util.*

class UtilsTest {

    @Test
    fun prettyPeriod_day(){
        val period = Random().nextInt()
        val result = getPrettyPeriod(period, PeriodUnit.DAY)
        assertEquals(result.resId, R.plurals.pretty_period_day)
        assertEquals(result.args, period)
        assertEquals(result.quantity, period)
    }

    @Test
    fun prettyPeriod_week(){
        val period = Random().nextInt()
        val result = getPrettyPeriod(period, PeriodUnit.WEEK)
        assertEquals(result.resId, R.plurals.pretty_period_week)
        assertEquals(result.args, period)
        assertEquals(result.quantity, period)
    }

    @Test
    fun prettyPeriod_month(){
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
}
