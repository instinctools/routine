package com.instinctools.routine_kmp.model

enum class PeriodResetStrategy(val id: String) {
    FromNextEvent("BY_PERIOD"),
    FromNow("BY_DATE"),
    ;

    companion object {
        fun find(id: String) = values().find { it.id == id } ?: FromNextEvent
    }
}