package com.routine.android

import android.graphics.Typeface
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentResultListener
import androidx.lifecycle.Observer
import androidx.lifecycle.distinctUntilChanged
import com.routine.R
import com.routine.android.data.db.entity.PeriodUnit
import com.routine.android.vm.DetailsViewModel
import com.routine.android.vm.DetailsViewModelFactory
import com.routine.databinding.ActivityDetailsBinding
import kotlinx.coroutines.ExperimentalCoroutinesApi

const val ARG_PERIOD = "ARG_PERIOD"

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

        supportFragmentManager.setFragmentResultListener(ARG_PERIOD,
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
                binding.toolbar.menu.findItem(R.id.done).actionView.run {
                    isEnabled = s.isNotEmpty()
                    if (this is TextView) {
                        typeface = if (s.isNotEmpty()) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
                    }
                }
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
