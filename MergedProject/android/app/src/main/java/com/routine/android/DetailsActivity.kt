package com.routine.android

import android.graphics.Typeface
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentResultListener
import androidx.lifecycle.coroutineScope
import androidx.lifecycle.lifecycleScope
import com.routine.R
import com.routine.android.data.db.database
import com.routine.android.data.db.entity.PeriodUnit
import com.routine.android.data.db.entity.TodoEntity
import com.routine.databinding.ActivityDetailsBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.*

const val ARG_PERIOD = "ARG_PERIOD"

open class DetailsActivity : AppCompatActivity() {

    private val binding: ActivityDetailsBinding by viewBinding(ActivityDetailsBinding::inflate)

    var period = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        if (savedInstanceState != null) {
            period = savedInstanceState.getInt(ARG_PERIOD)
        }

        val id: String? = intent.getStringExtra("EXTRA_ID")
        lifecycle.coroutineScope.launch {
            var todo: TodoEntity? = null
            if (id != null) {
                todo = withContext(Dispatchers.IO) {
                    database().todos().getTodo(id)
                }
            }

            binding.toolbar.setNavigationOnClickListener {
                onBackPressed()
            }

            binding.toolbar.menu.findItem(R.id.done)
                .actionView.setOnClickListener {
                    Analitics.action("Save todo")
                    lifecycleScope.launch {
                        val periodUnit = binding.radio.checkedRadioButtonId
                            .let {
                                when (it) {
                                    R.id.every_day -> PeriodUnit.DAY
                                    R.id.every_week -> PeriodUnit.WEEK
                                    R.id.every_month -> PeriodUnit.MONTH
                                    else -> PeriodUnit.DAY
                                }
                            }
                        withContext(Dispatchers.IO) {
                            val todoEntity = TodoEntity(id ?: UUID.randomUUID().toString(),
                                    binding.text.text.toString(),
                                    period, periodUnit,
                                    calculateTimestamp(period, periodUnit))

                            database().todos().addTodo(todoEntity)
                        }
                        onBackPressed()
                    }
                }

            binding.everyDay.setOnClickListener {
                Analitics.action("Period picker")
                if (supportFragmentManager.findFragmentByTag(WheelPickerFragment::class.java.simpleName) == null) {
                    WheelPickerFragment().apply {
                        arguments = Bundle().apply {
                            putInt(ARG_PERIOD, period)
                        }
                    }.show(supportFragmentManager, WheelPickerFragment::class.java.simpleName)
                }
            }

            binding.text.addTextChangedListener(object : TextWatcher {
                override fun afterTextChanged(s: Editable?) {
                }

                override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
                }

                override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                    binding.toolbar.menu.findItem(R.id.done).actionView.run {
                        isEnabled = s.isNotEmpty()
                        if (this is TextView) {
                            typeface = if (s.isNotEmpty()) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
                        }
                    }
                }
            })

            binding.radio.setOnCheckedChangeListener { group, checkedId ->
                if (checkedId != R.id.every_day) {
                    period = 1
                }
            }

            if (todo != null) {
                binding.text.setText(todo.title)
                period = todo.period
                binding.radio.check(when (todo.periodUnit) {
                    PeriodUnit.DAY -> R.id.every_day
                    PeriodUnit.WEEK -> R.id.every_week
                    PeriodUnit.MONTH -> R.id.every_month
                })
            }
            supportFragmentManager.setFragmentResultListener(ARG_PERIOD,
                    this@DetailsActivity,
                    FragmentResultListener { requestKey, result ->
                        period = result.getInt(ARG_PERIOD)
                    })
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt(ARG_PERIOD, period)
    }
}
