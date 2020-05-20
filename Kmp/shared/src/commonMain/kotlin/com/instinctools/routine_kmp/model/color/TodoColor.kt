package com.instinctools.routine_kmp.model.color

class TodoColor(
    val red: Int,
    val green: Int,
    val blue: Int
) {

    val redD = red / VARIANTS
    val greenD = green / VARIANTS
    val blueD = blue / VARIANTS

    companion object {
        private const val VARIANTS = 255.0

        val EXPIRED_TODO = TodoColor(0xFF, 0x00, 0x00)
        val TODOS_START = TodoColor(255, 190, 67)
        val TODOS_END = TodoColor(255, 57, 55)
    }
}