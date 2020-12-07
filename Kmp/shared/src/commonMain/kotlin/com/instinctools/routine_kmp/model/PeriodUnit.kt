package com.instinctools.routine_kmp.model

import kotlinx.datetime.DateTimeUnit

enum class PeriodUnit(
    val id: String,
    val dateTimeUnit: DateTimeUnit.DateBased
) {
    DAY("DAY", DateTimeUnit.DAY),
    WEEK("WEEK", DateTimeUnit.WEEK),
    MONTH("MONTH", DateTimeUnit.MONTH),
    YEAR("YEAR", DateTimeUnit.YEAR);

    companion object {
        val possiblePeriodValues = (1..59).toList()
        val possiblePeriodValuesZeroPadded = possiblePeriodValues.map { it.toString().padStart(2, '0') }

        fun find(id: String) = values().find { it.id == id } ?: DAY
    }
}