package com.instinctools.routine_kmp.model

enum class PeriodUnit(val id: String) {
    DAY("day"),
    WEEK("week"),
    MONTH("month"),
    YEAR("year");

    companion object {
        val possiblePeriodValues = (1..59).toList()
        val possiblePeriodValuesZeroPadded = possiblePeriodValues.map { it.toString().padStart(2, '0') }

        fun find(id: String) = values().find { it.id == id } ?: DAY
    }
}