package com.instinctools.routine_kmp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.instinctools.routine_kmp.databinding.MainBinding

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = MainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.helloText.text = friendlyMessage()
    }
}