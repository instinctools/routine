package com.instinctools.routine_kmp.model.todo

import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit

data class Todo(
    val id: String,
    val title: String,
    val periodUnit: PeriodUnit,
    val periodValue: Int,
    val periodStrategy: PeriodResetStrategy,
    val nextTimestamp: Long
) {

    constructor(
        title: String,
        periodUnit: PeriodUnit,
        periodValue: Int,
        periodStrategy: PeriodResetStrategy,
        nextTimestamp: Long
    ) : this(NO_ID, title, periodUnit, periodValue, periodStrategy, nextTimestamp)

    companion object {
        const val NO_ID = ""
    }
}