package com.routine.common.home

import com.routine.R

const val MENU_TECHNOLOGY = 0
const val MENU_SETTINGS = 1
const val MENU_TERMS = 2

enum class Menu(val id: Int, val icon: Int, val title: Int) {
    TECHNOLOGY(MENU_TECHNOLOGY, R.drawable.ic_technology, R.string.menu_technology),
    SETTINGS(MENU_SETTINGS, R.drawable.ic_settings, R.string.menu_settings),
    TERMS(MENU_TERMS, R.drawable.ic_alert, R.string.menu_terms),
}
