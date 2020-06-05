package com.instinctools.routine_kmp.model

data class Todo(
    val id: Long,
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
        const val NO_ID = -1L
    }
}