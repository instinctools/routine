package com.routine.common.vm

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.preference.PreferenceManager
import androidx.hilt.lifecycle.ViewModelInject
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.routine.App
import com.routine.common.data.repo.SettingsRepository
import com.routine.common.ui.home.menu.Menu
import com.routine.common.ui.home.menu.MenuData
import com.routine.common.ui.home.menu.MenuData.MenuTechnology
import com.routine.data.model.Event
import com.routine.data.provider.CpuProvider
import com.routine.data.provider.FpsProvider
import com.routine.data.provider.MemoryProvider
import com.routine.vm.status.Status
import com.routine.vm.status.cache
import com.routine.vm.status.statusCache
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class HomeViewModel @ViewModelInject constructor(private val settingsRepository: SettingsRepository): ViewModel() {

    private val menus_ = MutableStateFlow(listOf(
            MenuData.HeaderMenu(),
            MenuTechnology(true, false, null),
            MenuData.SimpleMenu(false, Menu.SETTINGS)))

    private val content_ = MutableStateFlow<Menu?>(null)

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

    val content by cache(CONTENT, start = true) {
        content_.map {
            if (it != null) {
                (Event(it))
            } else {
                PreferenceManager.getDefaultSharedPreferences(App.CONTEXT)
                    .getString(PREF_MENU, Menu.ANDROID_NATIVE.name)?.let {
                        val selectedMenu = Menu.valueOf(it)
                        menus_.value = menus_.value.map {
                            when (it) {
                                is MenuTechnology -> it.copy(true, selectedSubMenu = selectedMenu)
                                else -> it
                            }
                        }
                        Event(selectedMenu)
                    }
            }
        }
            .filterNotNull()
    }

    val profilerEnabled by statusCache {
        settingsRepository.isProfilerEnabled()
    }

    val hardwareInfo by statusCache(PROFILER, true) {
        profilerEnabled
            .filterIsInstance<Status.Data<Boolean>>()
            .map { it.value }
            .flatMapLatest {
                if (it) {
                    settingsRepository.profilerInterval()
                        .flatMapLatest {
                            combine(
                                    cpuProvider.cpuFlow(it),
                                    memoryProvider.memoryFlow(it),
                                    fpsProvider.fpsFlow(it)
                            ) { cpu, memory, fps ->
                                Triple(cpu, memory, fps)
                            }
                        }
                } else {
                    emptyFlow()
                }
            }
    }

    @SuppressLint("ApplySharedPref")
    fun onMenuSelected(menu: Menu) {
        content_.value = menu
        menus_.value = menus_.value.map {
            when (it) {
                is MenuData.SimpleMenu -> {
                    it.copy(menu == Menu.SETTINGS || (it.isSelected && menu == Menu.TECHNOLOGY))
                }
                is MenuTechnology -> when (menu) {
                    Menu.TECHNOLOGY -> it.copy(expanded = !it.expanded)
                    Menu.ANDROID_NATIVE, Menu.REACT_NATIVE, Menu.FLUTTER, Menu.KMP ->
                        it.copy(true, it.expanded, menu)
                            .also {
                                viewModelScope.launch(Dispatchers.IO) {
                                    PreferenceManager.getDefaultSharedPreferences(App.CONTEXT)
                                        .edit()
                                        .putString(PREF_MENU, menu.name)
                                        .commit()
                                }
                            }
                    else -> MenuTechnology(false, false, null)
                }
                else -> it
            }
        }
    }

    fun onMenuClicked() {
        menuClicks_.value = Event(Any())
    }
}
