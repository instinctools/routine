package com.instinctools.routine_kmp.model

enum class PeriodResetStrategy(val id: Int) {
    IntervalBased(0),
    FromNow(1),
    ;

    companion object {
        fun find(id: Int) = values().find { it.id == id } ?: IntervalBased
    }
}