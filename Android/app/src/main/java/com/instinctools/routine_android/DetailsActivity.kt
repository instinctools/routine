package com.instinctools.routine_android

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.coroutineScope
import androidx.lifecycle.lifecycleScope
import com.instinctools.routine_android.data.db.database
import com.instinctools.routine_android.data.db.entity.PeriodUnit
import com.instinctools.routine_android.data.db.entity.TodoEntity
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

        val id: String? = intent.getStringExtra("EXTRA_ID")
        lifecycle.coroutineScope.launch {
            var todo: TodoEntity? = null
            if (id != null) {
                todo = withContext(Dispatchers.IO) {
                    database().todos().getTodo(id)
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

            binding.toolbar.setNavigationOnClickListener {
                onBackPressed()
            }

            binding.toolbar.menu.findItem(R.id.done)
                .actionView.setOnClickListener {
                    lifecycleScope.launch {
                        withContext(Dispatchers.IO) {
                            val todoEntity = TodoEntity(UUID.randomUUID().toString(), title, period, periodUnit, calculateTimestamp(period, periodUnit))
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
    }
}
