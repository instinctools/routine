package com.instinctools.routine_kmp.ui.todo.details

sealed class ValidationError {
    object EmptyTitle : ValidationError()
    object PeriodNotSelected : ValidationError()
}