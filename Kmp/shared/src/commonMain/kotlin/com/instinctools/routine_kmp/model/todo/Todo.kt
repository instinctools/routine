package com.instinctools.routine_kmp.model.todo

import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import kotlinx.datetime.LocalDate

data class Todo(
    val id: String,
    val title: String,
    val periodUnit: PeriodUnit,
    val periodValue: Int,
    val periodStrategy: PeriodResetStrategy,
    val nextDate: LocalDate
) {

    constructor(
        title: String,
        periodUnit: PeriodUnit,
        periodValue: Int,
        periodStrategy: PeriodResetStrategy,
        nextDate: LocalDate
    ) : this(NO_ID, title, periodUnit, periodValue, periodStrategy, nextDate)

    companion object {
        const val NO_ID = ""
    }
}