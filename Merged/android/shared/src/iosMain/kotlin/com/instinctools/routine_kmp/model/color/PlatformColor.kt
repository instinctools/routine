package com.instinctools.routine_kmp.model.color

import platform.CoreImage.CIColor

actual typealias PlatformColor = CIColor

actual fun TodoColor.toPlatformColor(): CIColor {
    return CIColor(redD, greenD, blueD)
}