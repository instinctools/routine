package com.instinctools.routine_kmp.ui.splash

import android.os.Bundle
import android.view.View
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ActivitySplashBinding
import com.instinctools.routine_kmp.ui.RetainPresenterActivity
import com.instinctools.routine_kmp.ui.SplashPresenter
import com.instinctools.routine_kmp.ui.SplashPresenter.Action
import com.instinctools.routine_kmp.ui.SplashPresenter.State
import com.instinctools.routine_kmp.ui.list.TodoListActivity
import com.instinctools.routine_kmp.util.appComponent
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject
import javax.inject.Provider

class SplashActivity : RetainPresenterActivity<SplashPresenter>() {

    private lateinit var binding: ActivitySplashBinding

    @Inject lateinit var presenterProvider: Provider<SplashPresenter>

    override lateinit var presenter: SplashPresenter
    override val presenterCreator: () -> SplashPresenter = {
        presenterProvider.get()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySplashBinding.inflate(layoutInflater)
        setContentView(binding.root)

        appComponent.inject(this)

        createPresenter()
        setupUi()
    }

    override fun onStart() {
        super.onStart()
        presenter.states.onEach { state: State ->
            when (state) {
                State.Loading -> {
                    binding.btnRetry.visibility = View.GONE
                    binding.authMessage.setText(R.string.splash_auth_progress)
                    binding.progress.visibility = View.VISIBLE
                }
                is State.Error -> {
                    binding.btnRetry.visibility = View.VISIBLE
                    binding.authMessage.setText(R.string.splash_auth_error)
                    binding.progress.visibility = View.GONE
                }
                State.Success -> {
                    startActivity(TodoListActivity.buildIntent(this))
                }
            }
        }
            .launchIn(scope)
    }

    private fun setupUi() {
        binding.btnRetry.setOnClickListener {
            presenter.sendAction(Action.Login)
        }
    }
}