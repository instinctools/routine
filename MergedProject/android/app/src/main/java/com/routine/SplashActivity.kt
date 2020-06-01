package com.routine

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.asLiveData
import com.routine.android.viewBinding
import com.routine.android.vm.status.State
import com.routine.databinding.ActivitySplashBinding
import kotlinx.coroutines.ExperimentalCoroutinesApi

@ExperimentalCoroutinesApi
class SplashActivity : AppCompatActivity() {

    private val binding by viewBinding(ActivitySplashBinding::inflate)
    private val viewModel by viewModels<SplashViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        viewModel.getStatus(SplashViewModel.STATUS_LOGIN)
            .error
            .asLiveData()
            .observe(this, Observer {
                it.peekContent()?.let { error ->
                    binding.errorMessage.text = error.message
                }
            })

        viewModel.getStatus(SplashViewModel.STATUS_LOGIN)
            .state
            .asLiveData()
            .observe(this, Observer {
                when (it.peekContent()) {
                    State.PROGRESS -> adjustVisibility(true)
                    State.ERROR -> adjustVisibility(false)
                    else -> {
                        binding.errorMessage.text = ""
                        adjustVisibility(true)
                    }
                }
            })

        viewModel.result
            .observe(this, Observer {
                if (it) {
                    startActivity(Intent(this@SplashActivity, MainActivity::class.java))
                }
            })

        binding.retry.setOnClickListener {
            viewModel.onRefreshClicked()
        }
    }

    private fun adjustVisibility(isProgress: Boolean) {
        binding.errorGroup.visibility = if (isProgress) View.GONE else View.VISIBLE
        binding.progressText.visibility = if (isProgress) View.VISIBLE else View.GONE
    }
}
