package com.routine.common.home

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
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

@ExperimentalCoroutinesApi
class ActivityHome : AppCompatActivity(), DefaultHardwareBackBtnHandler {

    private val binding: ActivityHomeBinding by viewBinding(ActivityHomeBinding::inflate)
    private val adapter = MenuAdapter(lifecycleScope)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        binding.menu.adapter = adapter

        adapter.submitList(listOf(Menu.SETTINGS, Menu.TECHNOLOGY, Menu.TERMS))


        adapter.clicksFlow
            .onEach {
                when (it?.getContentIfNotHandled()) {
                    Menu.ANDROID_NATIVE -> {
                        supportFragmentManager.commit {
                            replace(R.id.content, Fragment(R.layout.fragment_android_app))
                        }
                    }
                    Menu.REACT_NATIVE -> {
                        supportFragmentManager.commit {
                            replace(
                                R.id.content, ReactFragment.Builder()
                                    .setComponentName("routine")
                                    .build()
                            )
                        }
                    }
                    Menu.FLUTTER -> {
                        supportFragmentManager.commit {
                            replace(
                                R.id.content,
                                FlutterFragment.NewEngineFragmentBuilder(FlutterAppFragment::class.java)
                                    .renderMode(RenderMode.surface)
                                    .transparencyMode(TransparencyMode.opaque)
                                    .build<FlutterAppFragment>()
                            )
                        }
                    }
                    Menu.KMP -> {

                    }
                    else -> {
                    }
                }
            }
            .launchIn(lifecycleScope)
    }

    override fun invokeDefaultOnBackPressed() {

    }
}
