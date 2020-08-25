package com.routine.common.home

import android.os.Bundle
import android.preference.PreferenceManager
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.GravityCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.commit
import androidx.lifecycle.lifecycleScope
import com.facebook.react.ReactFragment
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler
import com.routine.R
import com.routine.common.home.menu.Menu
import com.routine.common.home.menu.MenuAdapter
import com.routine.common.viewBinding
import com.routine.databinding.ActivityHomeBinding
import com.routine.flutter.FlutterAppFragment
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.android.TransparencyMode
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

const val SP_MENU = "MENU"

@ExperimentalCoroutinesApi
class ActivityHome : AppCompatActivity(), DefaultHardwareBackBtnHandler {

    private val binding: ActivityHomeBinding by viewBinding(ActivityHomeBinding::inflate)
    private val adapter = MenuAdapter(lifecycleScope)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        binding.menu.adapter = adapter

        PreferenceManager.getDefaultSharedPreferences(this)
            .getString(SP_MENU, Menu.ANDROID_NATIVE.name)?.let {
                handleMenu(Menu.valueOf(it))
            }

        adapter.submitList(listOf(Menu.TECHNOLOGY))


        adapter.clicksFlow
            .onEach {
                it?.getContentIfNotHandled()?.let {
                    handleMenu(it)
                }
            }
            .launchIn(lifecycleScope)
    }

    override fun invokeDefaultOnBackPressed() {
    }

    private fun handleMenu(menu: Menu) {
        when (menu) {
            Menu.ANDROID_NATIVE -> {
                openApp(Menu.ANDROID_NATIVE, Fragment(R.layout.fragment_android_app))
            }
            Menu.REACT_NATIVE -> {
                openApp(Menu.REACT_NATIVE, ReactFragment.Builder()
                    .setComponentName("routine")
                    .build())
            }
            Menu.FLUTTER -> {
                openApp(Menu.FLUTTER, FlutterFragment.NewEngineFragmentBuilder(FlutterAppFragment::class.java)
                    .renderMode(RenderMode.surface)
                    .transparencyMode(TransparencyMode.opaque)
                    .build<FlutterAppFragment>())
            }
            Menu.KMP -> {
            }
            else -> {
            }
        }
    }

    private fun openApp(menu: Menu, fragment: Fragment) {
        supportFragmentManager.commit {
            replace(R.id.content, fragment)
        }
        binding.drawer.closeDrawer(GravityCompat.END, true)

        PreferenceManager.getDefaultSharedPreferences(this)
            .edit()
            .putString(SP_MENU, menu.name)
            .apply()
    }
}
