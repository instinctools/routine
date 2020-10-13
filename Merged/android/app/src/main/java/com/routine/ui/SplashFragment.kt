package com.routine.ui

import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.routine.R
import com.routine.common.viewBinding
import com.routine.databinding.FragmentSplashBinding
import com.routine.vm.SplashViewModel
import com.routine.vm.status.StatusCache
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class SplashFragment : Fragment(R.layout.fragment_splash) {

    private val binding by viewBinding(FragmentSplashBinding::bind)
    private val viewModel by viewModels<SplashViewModel>()

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        viewModel.login
            .onEach {
                Log.d("TEST123", "$it")
                when (it) {
                    is StatusCache.Status.Loading -> adjustVisibility(true)
                    is StatusCache.Status.Data -> {
                        if (it.value) {
                            findNavController().navigate(R.id.action_splash_todos)
                        }
                    }
                    is StatusCache.Status.Error -> adjustVisibility(false)
                }
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

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
