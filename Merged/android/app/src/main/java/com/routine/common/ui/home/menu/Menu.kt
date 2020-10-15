package com.routine.common.ui.home.menu

import com.routine.R

// compile time constants
enum class Menu(val id: Int, val icon: Int?, val title: Int) {
    TECHNOLOGY(0, R.drawable.ic_technology, R.string.menu_technology),
    SETTINGS(1, R.drawable.ic_settings, R.string.menu_settings),
    TERMS(2, R.drawable.ic_alert, R.string.menu_terms),

    ANDROID_NATIVE(3, null, R.string.technology_android_native),
    REACT_NATIVE(4, null, R.string.technology_react_native),
    FLUTTER(5, null, R.string.technology_flutter),
    KMP(6, null, R.string.technology_kmp),
}

//state
sealed class MenuData {
    class HeaderMenu: MenuData()
    data class SimpleMenu(val isSelected: Boolean, val menu: Menu) : MenuData()
    data class MenuTechnology(val isSelected: Boolean, val expanded: Boolean, val selectedSubMenu: Menu?) : MenuData()
}
