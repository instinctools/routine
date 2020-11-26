package com.instinctools.routine_kmp.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.instinctools.routine_kmp.databinding.ActivityMainBinding
import com.instinctools.routine_kmp.ui.splash.SplashFragment

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    lateinit var rootNavigator: RootNavigator

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        rootNavigator = RootNavigatorImpl(binding.fragmentContainer.id, supportFragmentManager)

        if (savedInstanceState == null) {
            rootNavigator.goto(SplashFragment.newInstance())
        }
    }
}