package com.instinctools.routine_android

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.instinctools.routine_android.data.db.entity.PeriodUnit
import com.instinctools.routine_android.data.db.entity.TodoEntity
import com.instinctools.routine_android.data.db.database
import com.instinctools.routine_android.databinding.ActivityDetailsBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.*

open class DetailsActivity : AppCompatActivity() {

    private val binding: ActivityDetailsBinding by viewBinding(ActivityDetailsBinding::inflate)

    var title = "TEST123"
    var period = 1
    var periodUnit = PeriodUnit.DAY

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        binding.toolbar.setNavigationOnClickListener {
            onBackPressed()
        }

        binding.toolbar.menu.findItem(R.id.done)
            .actionView.setOnClickListener {
                lifecycleScope.launch {
                    withContext(Dispatchers.IO) {
                        val todoEntity = TodoEntity(UUID.randomUUID().toString(), title, period, periodUnit, calculateTimestamp())
                        database().todos().addTodo(todoEntity)
                    }
                    onBackPressed()
                }
            }

        binding.everyDay.setOnClickListener {
            WheelPickerFragment().show(supportFragmentManager, WheelPickerFragment::class.java.simpleName)
        }

        binding.radio.setOnCheckedChangeListener { _, checkedId ->
            val periodUnit = when (checkedId) {
                R.id.every_day -> PeriodUnit.DAY
                R.id.every_week -> PeriodUnit.WEEK
                R.id.every_month -> PeriodUnit.MONTH
                else -> PeriodUnit.DAY
            }
        }
    }

    private fun calculateTimestamp(): Date {
        val calendar = Calendar.getInstance()
        when (periodUnit) {
            PeriodUnit.DAY -> calendar.add(Calendar.DAY_OF_WEEK, period)
            PeriodUnit.WEEK -> calendar.add(Calendar.WEEK_OF_MONTH, period)
            PeriodUnit.MONTH -> calendar.add(Calendar.MONTH, period)
        }
        return calendar.time
    }
}
