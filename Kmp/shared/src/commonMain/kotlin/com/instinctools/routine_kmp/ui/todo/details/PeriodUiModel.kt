package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.model.PeriodUnit

data class PeriodUiModel(
    val unit: PeriodUnit,
    val count: Int = 1,
    val selected: Boolean = false
)