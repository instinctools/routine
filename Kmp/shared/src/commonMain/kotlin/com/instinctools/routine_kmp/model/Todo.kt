package com.instinctools.routine_kmp.model

import com.instinctools.routine_kmp.data.date.dateForTimestamp
import com.instinctools.routine_kmp.data.date.plus
import com.instinctools.routine_kmp.data.date.timestamp

data class Todo(
    val id: Long,
    val title: String,
    val periodUnit: PeriodUnit,
    val periodValue: Int,
    val nextTimestamp: Long
) {

    fun reset(): Todo {
        val oldDate = dateForTimestamp(nextTimestamp)
        val newDate = oldDate.plus(periodUnit, periodValue)
        return copy(nextTimestamp = newDate.timestamp)
    }

    constructor(title: String, periodUnit: PeriodUnit, periodValue: Int, nextTimestamp: Long) : this(NO_ID, title, periodUnit, periodValue, nextTimestamp)

    companion object {
        const val NO_ID = -1L
    }
}