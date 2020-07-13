package com.instinctools.routine_kmp.model.color

import android.graphics.Color

actual typealias PlatformColor = Int

actual fun TodoColor.toPlatformColor(): Int {
    return Color.rgb(red, green, blue)
}