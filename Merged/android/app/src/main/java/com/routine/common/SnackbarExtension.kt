@file:Suppress("unused")

package com.routine.common

import androidx.annotation.StringRes
import androidx.coordinatorlayout.widget.CoordinatorLayout
import com.google.android.material.snackbar.BaseTransientBottomBar
import com.google.android.material.snackbar.Snackbar

fun Snackbar.applyTextAndVisibility(text: CharSequence?) {
    if (!text.isNullOrBlank()) {
        if (isShownOrQueued) {
            addCallback(object : Snackbar.Callback() {
                override fun onShown(snackbar: Snackbar?) {
                    super.onShown(snackbar)
                    removeCallback(this)
                    snackbar?.view?.post { snackbar.setText(text).show() }
                }

                override fun onDismissed(snackbar: Snackbar?, event: Int) {
                    super.onDismissed(snackbar, event)
                    removeCallback(this)
                    snackbar?.view?.post { snackbar.setText(text).show() }
                }
            })
        } else {
            setText(text).show()
        }
    } else if (isShownOrQueued) {
        dismiss()
    }
}

fun CoordinatorLayout.snackbar(@StringRes resId: Int, @BaseTransientBottomBar.Duration duration: Int = BaseTransientBottomBar.LENGTH_LONG) = Snackbar.make(this, resId, duration)

fun CoordinatorLayout.snackbar(text: CharSequence, @BaseTransientBottomBar.Duration duration: Int = BaseTransientBottomBar.LENGTH_LONG) = Snackbar.make(this, text, duration)
