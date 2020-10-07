package com.routine.data.model

import android.content.res.Resources

class ResStringWrapper(val resId: Int, val args: Any?, val quantity: Int) {

    fun getString(resources: Resources): String =
        if (quantity > 0) {
            if (args != null) {
                resources.getQuantityString(resId, quantity, args)
            } else {
                resources.getQuantityString(resId, quantity)
            }
        } else {
            if (args != null) {
                resources.getString(resId, args)
            } else {
                resources.getString(resId)
            }
        }
}
