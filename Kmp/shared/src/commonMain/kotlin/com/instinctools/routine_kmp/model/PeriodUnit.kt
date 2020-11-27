package com.instinctools.routine_kmp.model

import kotlinx.datetime.DateTimeUnit

enum class PeriodUnit(
    val id: String,
    val dateTimeUnit: DateTimeUnit.DateBased
) {
    DAY("day", DateTimeUnit.DAY),
    WEEK("week", DateTimeUnit.WEEK),
    MONTH("month", DateTimeUnit.MONTH),
    YEAR("year", DateTimeUnit.YEAR);

    companion object {
        val possiblePeriodValues = (1..59).toList()
        val possiblePeriodValuesZeroPadded = possiblePeriodValues.map { it.toString().padStart(2, '0') }

        fun find(id: String) = values().find { it.id == id } ?: DAY
    }
}