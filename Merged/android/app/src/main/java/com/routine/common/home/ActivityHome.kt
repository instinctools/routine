package com.routine.common.home

import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.GravityCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.commit
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.SimpleItemAnimator
import com.facebook.react.ReactFragment
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler
import com.routine.R
import com.routine.common.home.menu.Menu
import com.routine.common.home.menu.MenuAdapter
import com.routine.common.home.vm.HomeViewModel
import com.routine.common.react.ReactAppModule
import com.routine.common.viewBinding
import com.routine.databinding.ActivityHomeBinding
import com.routine.flutter.FlutterAppFragment
import com.routine.ui.AndroidAppFragment
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.android.TransparencyMode
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import java.lang.ref.WeakReference

@ExperimentalCoroutinesApi
class ActivityHome : AppCompatActivity(), DefaultHardwareBackBtnHandler {

    private val viewModel by viewModels<HomeViewModel>()
    private val binding: ActivityHomeBinding by viewBinding(ActivityHomeBinding::inflate)
    private val adapter = MenuAdapter(lifecycleScope)

    private val menuClickListener = {
        viewModel.onMenuClicked()
    }

    @FlowPreview
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        binding.menu.adapter = adapter

        binding.menu.itemAnimator.apply {
            if (this is SimpleItemAnimator) {
                supportsChangeAnimations = false
            }
        }

        ReactAppModule.menuClickListener = WeakReference(menuClickListener)

        viewModel.menuClicks
            .onEach {
                if (!it.hasBeenHandled){
                    if (binding.drawer.isDrawerOpen(GravityCompat.END)){
                        binding.drawer.closeDrawer(GravityCompat.END, true)
                    } else {
                        binding.drawer.openDrawer(GravityCompat.END, true)
                    }
                }
            }
            .launchIn(lifecycleScope)

        viewModel.content
            .flowOn(Dispatchers.IO)
            .onEach {
                it.getContentIfNotHandled()?.let {
                    handleContentChanges(it)
                }
            }
            .launchIn(lifecycleScope)

        viewModel.menus
            .flowOn(Dispatchers.IO)
            .onEach {
                adapter.submitList(it)
            }
            .launchIn(lifecycleScope)


        adapter.clicksFlow
            .onEach {
                it?.getContentIfNotHandled()?.let {
                    viewModel.onMenuSelected(it)
                }
            }
            .launchIn(lifecycleScope)
    }

    override fun invokeDefaultOnBackPressed() {
    }

    private fun handleContentChanges(menu: Menu) {
        when (menu) {
            Menu.ANDROID_NATIVE -> { openApp(AndroidAppFragment()) }
            Menu.REACT_NATIVE -> {
                openApp(ReactFragment.Builder()
                    .setComponentName("routine")
                    .build())
            }
            Menu.FLUTTER -> {
                openApp(FlutterFragment.NewEngineFragmentBuilder(FlutterAppFragment::class.java)
                    .renderMode(RenderMode.surface)
                    .renderMode(RenderMode.texture)
                    .transparencyMode(TransparencyMode.opaque)
                    .build<FlutterAppFragment>())
            }
            Menu.KMP -> {
            }
            else -> {
            }
        }
    }

    private fun openApp(fragment: Fragment) {
        supportFragmentManager.commit {
            replace(R.id.content, fragment)
        }
        binding.drawer.closeDrawer(GravityCompat.END, true)
    }
}
