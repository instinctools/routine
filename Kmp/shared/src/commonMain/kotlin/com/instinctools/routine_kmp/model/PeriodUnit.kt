package com.instinctools.routine_kmp.model

enum class PeriodUnit(val id: Int) {
    DAY(0),
    WEEK(1),
    MONTH(2),
    YEAR(3);

    companion object {
        val possiblePeriodValues = (0..59).toList()
        val possiblePeriodValuesZeroPadded = possiblePeriodValues.map { it.toString().padStart(2, '0') }

        fun find(id: Int) = values().find { it.id == id } ?: DAY
        fun allPeriods() = values().asList()
    }
}