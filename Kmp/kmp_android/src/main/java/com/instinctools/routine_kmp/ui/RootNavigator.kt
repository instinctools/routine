package com.instinctools.routine_kmp.ui

import androidx.fragment.app.Fragment

interface RootNavigator {
    fun goBack()
    fun goto(fragment: Fragment, addToBackStack: Boolean = true)
}