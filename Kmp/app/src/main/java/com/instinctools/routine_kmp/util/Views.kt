package com.instinctools.routine_kmp.util

import android.widget.TextView

fun TextView.setTextIfChanged(value: CharSequence?) {
    val oldText = text?.toString()
    val newText = value?.toString()
    val isTextTheSame = oldText == newText || (oldText.isNullOrEmpty() && newText.isNullOrEmpty())
    if (!isTextTheSame) text = value
}
