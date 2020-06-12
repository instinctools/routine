package com.instinctools.routine_kmp.ui.todo.details.model

sealed class ValidationError {
    object EmptyTitle : ValidationError()
    object PeriodNotSelected : ValidationError()
}