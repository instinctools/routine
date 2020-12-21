package com.instinctools.routine_kmp.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.commit
import com.instinctools.routine_kmp.databinding.ActivityMainBinding
import com.instinctools.routine_kmp.ui.splash.SplashFragment

class MainActivity : AppCompatActivity(), RootNavigator {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        if (savedInstanceState == null) {
            goto(SplashFragment.newInstance())
        }
    }

    override fun goBack() {
        supportFragmentManager.popBackStackImmediate()
    }

    override fun goto(fragment: Fragment, addToBackStack: Boolean) {
        supportFragmentManager.commit {
            replace(binding.fragmentContainer.id, fragment)
            if (addToBackStack) addToBackStack(null)
        }
    }
}