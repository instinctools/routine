package com.instinctools.routine_kmp.ui.todo.details.model

import com.instinctools.routine_kmp.model.PeriodUnit

data class PeriodUnitUiModel(
    val unit: PeriodUnit,
    val count: Int = 1
)

fun allPeriodUiModels() = PeriodUnit.values().map { PeriodUnitUiModel(it) }
fun List<PeriodUnitUiModel>.adjustCount(unit: PeriodUnit, count: Int) = map {
    if (it.unit == unit) {
        PeriodUnitUiModel(unit, count)
    } else it
}