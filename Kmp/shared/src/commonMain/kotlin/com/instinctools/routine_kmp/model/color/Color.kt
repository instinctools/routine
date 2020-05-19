package com.instinctools.routine_kmp.model.color

class Color(
    val red: Int,
    val green: Int,
    val blue: Int
) {

    companion object {
        val EXPIRED_TODO = Color(0xFF, 0x00, 0x00)
        val TODOS_START = Color(255, 190, 67)
        val TODOS_END = Color(255, 57, 55)
    }
}