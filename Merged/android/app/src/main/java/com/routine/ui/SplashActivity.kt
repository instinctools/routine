package com.routine.ui

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.asLiveData
import com.routine.R
import com.routine.common.viewBinding
import com.routine.databinding.ActivitySplashBinding
import com.routine.vm.SplashViewModel
import com.routine.vm.status.State
import kotlinx.coroutines.ExperimentalCoroutinesApi
import timber.log.Timber

@ExperimentalCoroutinesApi
class SplashActivity : AppCompatActivity() {

    private val binding by viewBinding(ActivitySplashBinding::inflate)
    private val viewModel by viewModels<SplashViewModel>()

    companion object{
        const val IS_PROGRESS = true
        const val IS_ERROR = false
    }

    @ExperimentalStdlibApi
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        viewModel.getStatus(SplashViewModel.STATUS_LOGIN)
            .error
            .asLiveData()
            .observe(this, Observer {
                it.peekContent()?.let { error ->
                    Timber.d(error, "STATUS_LOGIN error ")
                    adjustVisibility(IS_ERROR)
                }
            })

        viewModel.getStatus(SplashViewModel.STATUS_LOGIN)
            .state
            .asLiveData()
            .observe(this, Observer {
                when (it.peekContent()) {
                    State.EMPTY -> adjustVisibility(IS_PROGRESS)
                    State.PROGRESS -> adjustVisibility(IS_PROGRESS)
                    State.ERROR -> adjustVisibility(IS_ERROR)
                }
            })

        viewModel.result
            .observe(this, Observer {
                if (it) {
                    startActivity(Intent(this@SplashActivity, AndroidAppActivity::class.java))
                }
            })

        binding.retry.setOnClickListener {
            viewModel.onRefreshClicked()
        }
    }

    private fun adjustVisibility(isProgress: Boolean) {
        binding.retry.visibility = if (isProgress) View.GONE else View.VISIBLE
        binding.progressCircular.visibility = if (isProgress) View.VISIBLE else View.GONE
        binding.statusMessage.text =
            resources.getString(if (isProgress) R.string.splash_screen_status_progress else R.string.splash_screen_status_error)
    }
}
