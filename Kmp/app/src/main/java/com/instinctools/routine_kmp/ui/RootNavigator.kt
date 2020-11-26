package com.instinctools.routine_kmp.ui

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.commit

interface RootNavigator {
    fun goBack()
    fun goto(fragment: Fragment, addToBackStack: Boolean = true)
}

class RootNavigatorImpl(
    private val containerId: Int,
    private val fragmentManager: FragmentManager
) : RootNavigator {

    override fun goBack() {
        fragmentManager.popBackStackImmediate()
    }

    override fun goto(fragment: Fragment, addToBackStack: Boolean) {
        fragmentManager.commit {
            replace(containerId, fragment)
            if (addToBackStack) addToBackStack(null)
        }
    }
}