package com.routine.common.home

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.routine.common.viewBinding
import com.routine.databinding.ActivityHomeBinding

class ActivityHome : AppCompatActivity() {

    private val binding: ActivityHomeBinding by viewBinding(ActivityHomeBinding::inflate)
    private val adapter = MenuAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        binding.menu.adapter = adapter

        adapter.submitList(listOf(Menu.SETTINGS, Menu.TECHNOLOGY, Menu.TERMS))
    }
}
