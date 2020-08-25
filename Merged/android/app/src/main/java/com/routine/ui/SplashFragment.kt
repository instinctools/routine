package com.routine.ui

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.lifecycle.asLiveData
import androidx.navigation.fragment.findNavController
import com.routine.R
import com.routine.common.viewBinding
import com.routine.databinding.FragmentSplashBinding
import com.routine.vm.SplashViewModel
import com.routine.vm.status.State
import kotlinx.coroutines.ExperimentalCoroutinesApi
import timber.log.Timber

@ExperimentalCoroutinesApi
class SplashFragment : Fragment(R.layout.fragment_splash) {

    private val binding by viewBinding(FragmentSplashBinding::bind)
    private val viewModel by viewModels<SplashViewModel>()

    companion object{
        const val IS_PROGRESS = true
        const val IS_ERROR = false
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.getStatus(SplashViewModel.STATUS_LOGIN)
            .error
            .asLiveData()
            .observe(viewLifecycleOwner, Observer {
                it.peekContent()?.let { error ->
                    Timber.d(error, "STATUS_LOGIN error ")
                    adjustVisibility(IS_ERROR)
                }
            })

        viewModel.getStatus(SplashViewModel.STATUS_LOGIN)
            .state
            .asLiveData()
            .observe(viewLifecycleOwner, Observer {
                when (it.peekContent()) {
                    State.EMPTY -> adjustVisibility(IS_PROGRESS)
                    State.PROGRESS -> adjustVisibility(IS_PROGRESS)
                    State.ERROR -> adjustVisibility(IS_ERROR)
                }
            })

        viewModel.result
            .observe(viewLifecycleOwner, Observer {
                if (it) {
                    findNavController().navigate(R.id.action_splash_todos)
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
