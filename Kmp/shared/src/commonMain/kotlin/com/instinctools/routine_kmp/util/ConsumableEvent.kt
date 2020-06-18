package com.instinctools.routine_kmp.util

data class ConsumableEvent<T>(
    val item: T
) {
    var unhandled = true
        private set

    fun consume() {
        unhandled = false
    }
}