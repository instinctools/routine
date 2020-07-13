package com.instinctools.routine_kmp.model

enum class PeriodResetStrategy(val id: String) {
    FromNextEvent("from_event"),
    FromNow("from_now"),
    ;

    companion object {
        fun find(id: String) = values().find { it.id == id } ?: FromNextEvent
    }
}