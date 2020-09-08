package com.routine.common.home.menu

import com.routine.R

// compile time constants
enum class Menu(val icon: Int?, val title: Int) {
    TECHNOLOGY(R.drawable.ic_technology, R.string.menu_technology),
    SETTINGS(R.drawable.ic_settings, R.string.menu_settings),
    TERMS(R.drawable.ic_alert, R.string.menu_terms),

    ANDROID_NATIVE(null, R.string.technology_android_native),
    REACT_NATIVE(null, R.string.technology_react_native),
    FLUTTER(null, R.string.technology_flutter),
    KMP(null, R.string.technology_kmp),
}

//state
sealed class MenuData {
    class HeaderMenu: MenuData()
    data class SimpleMenu(val menu: Menu) : MenuData()
    data class MenuTechnology(val expanded: Boolean, val selectedSubMenu: Menu) : MenuData()
}