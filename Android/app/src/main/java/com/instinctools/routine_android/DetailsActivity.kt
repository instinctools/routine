package com.instinctools.routine_android

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import androidx.core.view.MenuItemCompat
import com.instinctools.routine_android.databinding.ActivityDetailsBinding
import com.instinctools.routine_android.databinding.ActivityMainBinding

class DetailsActivity : AppCompatActivity() {

    private val binding: ActivityDetailsBinding by viewBinding(ActivityDetailsBinding::inflate)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        binding.toolbar.setNavigationOnClickListener {
            onBackPressed()
        }

        binding.toolbar.menu.findItem(R.id.done)
            .actionView.setOnClickListener {

            }
    }
}
