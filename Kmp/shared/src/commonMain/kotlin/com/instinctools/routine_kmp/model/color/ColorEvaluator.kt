package com.instinctools.routine_kmp.model.color

import kotlin.math.pow

object ColorEvaluator {

    fun evaluate(fraction: Float, startColor: Color, endColor: Color): Color {
        var startR = startColor.red / 255.0f
        var startG = startColor.green / 255.0f
        var startB = startColor.blue / 255.0f

        var endR = endColor.red / 255.0f
        var endG = endColor.green / 255.0f
        var endB = endColor.blue / 255.0f

        // convert from sRGB to linear
        startR = startR.pow(2.2f)
        startG = startG.pow(2.2f)
        startB = startB.pow(2.2f)
        endR = endR.pow(2.2f)
        endG = endG.pow(2.2f)
        endB = endB.pow(2.2f)

        // compute the interpolated color in linear space
        var r = startR + fraction * (endR - startR)
        var g = startG + fraction * (endG - startG)
        var b = startB + fraction * (endB - startB)

        // convert back to sRGB in the [0..255] range
        val power = (1.0 / 2.2).toFloat()
        r = r.pow(power) * 255.0f
        g = g.pow(power) * 255.0f
        b = b.pow(power) * 255.0f
        return Color(r.toInt(), g.toInt(), b.toInt())
    }
}