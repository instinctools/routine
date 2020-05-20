package com.routine

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.activity.viewModels
import androidx.lifecycle.Observer
import androidx.lifecycle.asLiveData
import com.routine.android.viewBinding
import com.routine.databinding.ActivityHomeBinding
import com.routine.databinding.ActivitySplashBinding
import kotlinx.coroutines.ExperimentalCoroutinesApi

@ExperimentalCoroutinesApi
class SplashActivity : AppCompatActivity() {

    private val binding by viewBinding(ActivitySplashBinding::inflate)
    private val viewModel by viewModels<SplashViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        viewModel.error
            .observe(this, Observer {
                binding.errorMessage.text = it
            })

        viewModel.state
            .asLiveData()
            .observe(this, Observer {
                when (it) {
                    SplashViewModel.State.SUCCESS -> {
                        startActivity(Intent(this@SplashActivity, MainActivity::class.java))
                    }
                    SplashViewModel.State.PROGRESS -> adjustVisibility(true)
                    SplashViewModel.State.ERROR -> adjustVisibility(false)
                    else -> {
                        binding.errorMessage.text = ""
                        adjustVisibility(true)
                    }
                }
            })

        binding.retry.setOnClickListener {
            viewModel.process()
        }
    }

    private fun adjustVisibility(isProgress: Boolean) {
        binding.errorGroup.visibility = if (isProgress) View.GONE else View.VISIBLE
        binding.progressText.visibility = if (isProgress) View.VISIBLE else View.GONE
    }
}
