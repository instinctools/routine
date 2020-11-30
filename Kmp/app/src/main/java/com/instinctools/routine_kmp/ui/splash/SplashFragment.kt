package com.instinctools.routine_kmp.ui.splash

import android.os.Bundle
import android.view.View
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.FragmentSplashBinding
import com.instinctools.routine_kmp.ui.BaseFragment
import com.instinctools.routine_kmp.ui.SplashPresenter.Action
import com.instinctools.routine_kmp.ui.SplashPresenter.State
import com.instinctools.routine_kmp.ui.list.TodoListFragment
import com.instinctools.routine_kmp.util.injector
import com.instinctools.routine_kmp.util.presenterContainer
import com.instinctools.routine_kmp.util.rootNavigator
import com.instinctools.routine_kmp.util.viewBinding
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import timber.log.Timber

class SplashFragment : BaseFragment(R.layout.fragment_splash) {

    private val binding by viewBinding(FragmentSplashBinding::bind)
    private val container by presenterContainer { injector.splashPresenter }
    private val presenter get() = container.presenter

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.btnRetry.setOnClickListener { presenter.sendAction(Action.Login) }
        presenter.states.onEach { state: State ->
            when (state) {
                State.Loading -> {
                    binding.btnRetry.visibility = View.GONE
                    binding.authMessage.setText(R.string.splash_auth_progress)
                    binding.progress.visibility = View.VISIBLE
                }
                is State.Error -> {
                    Timber.e(state.error, "Failed to login")
                    binding.btnRetry.visibility = View.VISIBLE
                    binding.authMessage.setText(R.string.splash_auth_error)
                    binding.progress.visibility = View.GONE
                }
                State.Success -> {
                    rootNavigator.goto(TodoListFragment.newInstance())
                }
            }
        }
            .launchIn(viewScope)
    }

    companion object {
        fun newInstance() = SplashFragment()
    }
}