package com.instinctools.routine_kmp.model

data class Todo(
    val id: Long,
    val title: String,
    val periodUnit: PeriodUnit,
    val periodValue: Int,
    val nextTimestamp: Long
)