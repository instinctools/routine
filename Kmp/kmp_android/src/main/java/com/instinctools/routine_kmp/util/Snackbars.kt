package com.instinctools.routine_kmp.util

import android.view.View
import androidx.annotation.StringRes
import com.google.android.material.snackbar.Snackbar

fun View.snackbarOf(@StringRes messageResId: Int, duration: Int = Snackbar.LENGTH_SHORT) = Snackbar.make(this, messageResId, duration).show()