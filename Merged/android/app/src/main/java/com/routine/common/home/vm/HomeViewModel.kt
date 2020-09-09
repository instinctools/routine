package com.routine.common.home.vm

import android.annotation.SuppressLint
import android.preference.PreferenceManager
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.routine.App
import com.routine.common.home.menu.Menu
import com.routine.common.home.menu.MenuData
import com.routine.common.home.menu.MenuData.MenuTechnology
import com.routine.data.model.Event
import com.routine.vm.status.getAction
import com.routine.vm.status.wrapWithAction
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch

const val PREF_MENU = "MENU"

@ExperimentalCoroutinesApi
class HomeViewModel : ViewModel() {

    private val menus_ = MutableStateFlow(listOf(MenuData.HeaderMenu(), MenuTechnology(false, Menu.ANDROID_NATIVE)))
    private val menuClicks_ = MutableStateFlow(Event(Any()))

    val menus: Flow<List<MenuData>> = menus_
    val menuClicks: Flow<Event<Any>> = menuClicks_

    @FlowPreview
    val content by wrapWithAction(initialAction = Any()) {
        flow {
            PreferenceManager.getDefaultSharedPreferences(App.CONTEXT)
                .getString(PREF_MENU, Menu.ANDROID_NATIVE.name)?.let {
                    val selectedMenu = Menu.valueOf(it)
                    menus_.value = menus_.value.map {
                        when (it) {
                            is MenuTechnology -> MenuTechnology(it.expanded, selectedMenu)
                            else -> it
                        }
                    }
                    emit(Event(selectedMenu))
                }
        }
    }

    @FlowPreview
    @SuppressLint("ApplySharedPref")
    fun onMenuSelected(menu: Menu) {
        menus_.value = menus_.value.map {
            when (it) {
                is MenuTechnology -> when (menu) {
                    Menu.TECHNOLOGY -> MenuTechnology(!it.expanded, it.selectedSubMenu)
                    Menu.ANDROID_NATIVE, Menu.REACT_NATIVE, Menu.FLUTTER, Menu.KMP ->
                        MenuTechnology(it.expanded, menu)
                            .also {
                                viewModelScope.launch(Dispatchers.IO) {
                                    PreferenceManager.getDefaultSharedPreferences(App.CONTEXT)
                                        .edit()
                                        .putString(PREF_MENU, menu.name)
                                        .commit()
                                    getAction<Any>()?.proceed(Any())
                                }
                            }
                    else -> MenuTechnology(it.expanded, it.selectedSubMenu)
                }
                else -> it
            }
        }
    }

    fun onMenuClicked() {
        menuClicks_.value = Event(Any())
    }
}
