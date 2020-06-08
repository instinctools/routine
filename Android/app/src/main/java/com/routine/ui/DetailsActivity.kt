package com.routine.ui

import android.graphics.Typeface
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentResultListener
import androidx.lifecycle.Observer
import androidx.lifecycle.asLiveData
import androidx.lifecycle.distinctUntilChanged
import com.google.android.material.snackbar.Snackbar
import com.routine.R
import com.routine.common.Analytics
import com.routine.common.viewBinding
import com.routine.data.db.entity.PeriodUnit
import com.routine.databinding.ActivityDetailsBinding
import com.routine.vm.DetailsViewModel
import com.routine.vm.DetailsViewModel.Companion.STATUS_ADD_TODO
import com.routine.vm.DetailsViewModel.Companion.STATUS_GET_TODO
import com.routine.vm.DetailsViewModelFactory
import com.routine.vm.status.State
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.merge

const val ARG_PERIOD = "ARG_PERIOD"

@FlowPreview
@ExperimentalStdlibApi
@ExperimentalCoroutinesApi
open class DetailsActivity : AppCompatActivity() {

    private val binding: ActivityDetailsBinding by viewBinding(ActivityDetailsBinding::inflate)

    private val viewModel by viewModels<DetailsViewModel> { DetailsViewModelFactory(intent.getStringExtra("EXTRA_ID")) }

    private var period = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        viewModel.todo
            .distinctUntilChanged()
            .observe(this, Observer { todo ->
                if (binding.text.text.toString() != todo.title) {
                    binding.text.setText(todo.title)
                }

                period = todo.period

                binding.radio.check(when (todo.periodUnit) {
                    PeriodUnit.DAY -> R.id.every_day
                    PeriodUnit.WEEK -> R.id.every_week
                    PeriodUnit.MONTH -> R.id.every_month
                })
            })

        viewModel.getStatus(STATUS_GET_TODO)
            .state
            .asLiveData()
            .observe(this, Observer {
                when (it.peekContent()) {
                    State.PROGRESS -> {
                        binding.groupContent.visibility = View.GONE
                        binding.progress.visibility = View.VISIBLE
                    }
                    State.EMPTY -> {
                        binding.groupContent.visibility = View.VISIBLE
                        binding.progress.visibility = View.GONE
                    }
                    else -> {
                        binding.groupContent.visibility = View.GONE
                        binding.progress.visibility = View.GONE
                    }
                }
            })

        merge(viewModel.getStatus(STATUS_GET_TODO).error,
                viewModel.getStatus(STATUS_ADD_TODO).error)
            .asLiveData()
            .observe(this, Observer {
                val content = it.getContentIfNotHandled()
                if (content != null) {
                    Snackbar.make(binding.root, content.message ?: "An error occurred!", Snackbar.LENGTH_SHORT).show()
                }
            })

        viewModel.getStatus(STATUS_ADD_TODO)
            .state
            .asLiveData()
            .observe(this, Observer {
                binding.progress.visibility = if (it.peekContent() == State.PROGRESS) View.VISIBLE else View.GONE
            })

        viewModel.validation
            .asLiveData()
            .observe(this, Observer {
                binding.toolbar.menu.findItem(R.id.done).actionView.run {
                    isEnabled = it
                    if (this is TextView) {
                        typeface = if (it) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
                    }
                }
            })

        viewModel.addTodoResult
            .observe(this, Observer {
                if (it) onBackPressed()
            })

        supportFragmentManager.setFragmentResultListener(
            ARG_PERIOD,
                this@DetailsActivity,
                FragmentResultListener { requestKey, result ->
                    viewModel.onPeriodChanged(result.getInt(ARG_PERIOD))
                })

        binding.radio.setOnCheckedChangeListener { group, checkedId ->
            if (checkedId != R.id.every_day) {
                viewModel.onPeriodChanged(1)
            }
        }
        binding.text.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable?) {
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
            }

            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                viewModel.onTextChanged(s.toString())
            }
        })

        binding.radio.setOnCheckedChangeListener { group, checkedId ->
            val periodUnit = when (checkedId) {
                R.id.every_day -> PeriodUnit.DAY
                R.id.every_week -> PeriodUnit.WEEK
                R.id.every_month -> PeriodUnit.MONTH
                else -> PeriodUnit.DAY
            }
            viewModel.onPeriodUnitChanged(periodUnit)
        }

        binding.everyDay.setOnClickListener {
            Analytics.action("period_picker_android")
            if (supportFragmentManager.findFragmentByTag(WheelPickerFragment::class.java.simpleName) == null) {
                WheelPickerFragment().apply {
                    arguments = Bundle().apply {
                        putInt(ARG_PERIOD, period)
                    }
                }.show(supportFragmentManager, WheelPickerFragment::class.java.simpleName)
            }
        }

        binding.toolbar.setNavigationOnClickListener {
            onBackPressed()
        }

        binding.toolbar.menu.findItem(R.id.done)
            .actionView.setOnClickListener {
                Analytics.action("save_todo_android")
                viewModel.saveTodo()
            }
    }
}
