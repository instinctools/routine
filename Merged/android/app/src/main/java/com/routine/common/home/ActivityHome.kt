package com.routine.common.home

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.routine.common.home.menu.Menu
import com.routine.common.home.menu.MenuAdapter
import com.routine.common.viewBinding
import com.routine.databinding.ActivityHomeBinding
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import timber.log.Timber

@ExperimentalCoroutinesApi
class ActivityHome : AppCompatActivity() {

    private val binding: ActivityHomeBinding by viewBinding(ActivityHomeBinding::inflate)
    private val adapter = MenuAdapter(lifecycleScope)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        binding.menu.adapter = adapter

        adapter.submitList(listOf(Menu.SETTINGS, Menu.TECHNOLOGY, Menu.TERMS))


        adapter.clicksFlow
            .onEach {
                Timber.d("menu clicked: ${it?.peekContent()}")
            }
            .launchIn(lifecycleScope)
    }
}
