package com.instinctools.routine_kmp.model

enum class PeriodUnit(val id: Int) {
    DAY(0),
    WEEK(1),
    MONTH(2),
    YEAR(3);

    companion object {
        fun find(id: Int) = values().find { it.id == id } ?: DAY
        fun allPeriods() = values().asList()
    }
}