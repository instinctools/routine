package com.instinctools.routine_kmp.util

import androidx.fragment.app.Fragment
import kotlin.properties.ReadOnlyProperty

inline fun <reified T> Fragment.argument(key: String): ReadOnlyProperty<Fragment, T> = ReadOnlyProperty { _, _ ->
    val bundle = arguments
    requireNotNull(bundle) { "Arguments should be provided " }
    bundle.get(key) as T
}
