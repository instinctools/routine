package com.instinctools.routine_kmp.model

data class Todo(
    val id: Int,
    val title: String,
    val periodType: PeriodType,
    val periodValue: Int,
    val nextTimestamp: Long
)