package com.routine.common.home.vm

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.preference.PreferenceManager
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.routine.App
import com.routine.common.home.menu.Menu
import com.routine.common.home.menu.MenuData
import com.routine.common.home.menu.MenuData.MenuTechnology
import com.routine.data.model.Event
import com.routine.data.provider.CpuProvider
import com.routine.data.provider.FpsProvider
import com.routine.data.provider.MemoryProvider
import com.routine.vm.status.cache
import com.routine.vm.status.paramCache
import com.routine.vm.status.repeatAction
import com.routine.vm.status.statusCache
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class HomeViewModel : ViewModel() {

    private val menus_ = MutableStateFlow(listOf(MenuData.HeaderMenu(), MenuTechnology(false, Menu.ANDROID_NATIVE)))
    private val menuClicks_ = MutableStateFlow(Event(Any()))
    private val profilingEnabled_ = MutableStateFlow(true)

    val menus: Flow<List<MenuData>> = menus_
    val menuClicks: Flow<Event<Any>> = menuClicks_

    private val cpuProvider = CpuProvider()
    private val memoryProvider = MemoryProvider(App.CONTEXT.getSystemService(ActivityManager::class.java))
    private val fpsProvider = FpsProvider()

    companion object {
        const val PREF_MENU = "MENU"
        const val CONTENT = "CONTENT"
        const val PROFILER = "PROFILER"
    }

    val content by cache (CONTENT, start = true) {
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

    val hardwareInfo by statusCache (PROFILER, true) {
        profilingEnabled_
            .flatMapLatest {
                if (it) {
                    combine(
                        cpuProvider.cpuFlow(1000),
                        memoryProvider.memoryFlow(1000),
                        fpsProvider.fpsFlow(1000)
                    ) { cpu, memory, fps ->
                        Triple(cpu, memory, fps)
                    }
                } else {
                    emptyFlow()
                }
            }
    }

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
                                    repeatAction(CONTENT)
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
