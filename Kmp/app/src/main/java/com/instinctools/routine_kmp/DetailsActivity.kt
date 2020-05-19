package com.instinctools.routine_kmp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.instinctools.routine_kmp.databinding.ActivityDetailsBinding

class DetailsActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = ActivityDetailsBinding.inflate(layoutInflater)
        setContentView(binding.root)
    }
}