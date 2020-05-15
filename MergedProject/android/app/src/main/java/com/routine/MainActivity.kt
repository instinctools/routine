package com.routine

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.routine.android.Analytics
import com.routine.android.AndroidAppActivity
import com.routine.android.viewBinding
import com.routine.databinding.ActivityHomeBinding

class MainActivity : AppCompatActivity() {
    private val binding: ActivityHomeBinding by viewBinding(ActivityHomeBinding::inflate)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        binding.btnAndroidApp.setOnClickListener {
            Analytics.action("open_android_app")
            startActivity(Intent(this, AndroidAppActivity::class.java))
        }

        binding.btnReactApp.setOnClickListener {
            Analytics.action("open_react_app")
            startActivity(Intent(this, ReactAppActivity::class.java))
        }

        binding.btnFlutterApp.setOnClickListener {
            Analytics.action("open_flutter_app")
            startActivity(Intent(this, FlutterAppActivity::class.java))
        }
    }
}