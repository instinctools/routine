package com.instinctools.routine_kmp.ui.details

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.widget.doOnTextChanged
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.data.AndroidDatabaseProvider
import com.instinctools.routine_kmp.data.database.SqlTodoStore
import com.instinctools.routine_kmp.databinding.ActivityDetailsBinding
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class TodoDetailsActivity : AppCompatActivity() {

    private lateinit var binding: ActivityDetailsBinding

    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private lateinit var presenter: TodoDetailsPresenter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDetailsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        var todoId: Long? = intent.getLongExtra(ARG_TODO_ID, NO_ID)
        if (todoId == NO_ID) {
            todoId = null
        }

        setupUi()

        val databaseProvider = AndroidDatabaseProvider(applicationContext)
        val todoStore = SqlTodoStore(databaseProvider.database())

        presenter = TodoDetailsPresenter(todoId, todoStore)
        presenter.start()
    }

    override fun onStart() {
        super.onStart()
        presenter.states.onEach { state ->
            binding.text.setText(state.todo.title)
        }
            .launchIn(scope)
    }

    override fun onStop() {
        super.onStop()
        scope.cancelChildren()
    }

    override fun onDestroy() {
        super.onDestroy()
        presenter.stop()
    }

    private fun setupUi() {
        binding.toolbar.setNavigationOnClickListener { onBackPressed() }
        binding.everyDay.setOnClickListener {
            val fragment = supportFragmentManager.findFragmentByTag(WheelPickerFragment.TAG)
            if (fragment == null) {
                // Todo adjust period
                WheelPickerFragment.newInstance(1)
                    .show(supportFragmentManager, WheelPickerFragment.TAG)
            }
        }
        binding.text.doOnTextChanged { text, _, _, _ ->
            val event = TodoDetailsPresenter.Event.ChangeTitle(text?.toString())
            presenter.events.offer(event)
        }
        binding.toolbar.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.done -> {
                    presenter.events.offer(TodoDetailsPresenter.Event.Save)
                    true
                }
                else -> false
            }
        }
        binding.radio.setOnCheckedChangeListener { _, checkedId ->
            val periodUnit = when (checkedId) {
                R.id.every_day -> PeriodUnit.DAY
                R.id.every_week -> PeriodUnit.WEEK
                R.id.every_month -> PeriodUnit.MONTH
                R.id.every_year -> PeriodUnit.YEAR
                else -> PeriodUnit.DAY
            }
            presenter.events.offer(TodoDetailsPresenter.Event.ChangePeriodUnit(periodUnit))
        }
    }

    companion object {
        private const val ARG_TODO_ID = "todo_id"
        private const val NO_ID = -1L

        fun buildIntent(context: Context, todoId: Long?) = Intent(context, TodoDetailsActivity::class.java).apply {
            putExtra(ARG_TODO_ID, todoId ?: NO_ID)
        }
    }
}