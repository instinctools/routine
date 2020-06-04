package com.instinctools.routine_kmp.ui.details

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.widget.doOnTextChanged
import androidx.recyclerview.widget.LinearLayoutManager
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ActivityDetailsBinding
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.ui.details.adapter.PeriodsAdapter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenterFactory
import com.instinctools.routine_kmp.ui.widget.VerticalSpacingDecoration
import com.instinctools.routine_kmp.util.appComponent
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject

class TodoDetailsActivity : AppCompatActivity() {

    private lateinit var binding: ActivityDetailsBinding

    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    @Inject lateinit var presenterProvider: TodoDetailsPresenterFactory
    private lateinit var presenter: TodoDetailsPresenter

    private val adapter = PeriodsAdapter(
        selectionListener = { _, item ->
            presenter.events.offer(TodoDetailsPresenter.Event.ChangePeriodUnit(item))
        },
        countChooserListener = { position, item ->
            presenter.events.offer(TodoDetailsPresenter.Event.ChangePeriodUnit(item))
            showCountChooser()
        }
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDetailsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        appComponent.inject(this)

        var todoId: Long? = intent.getLongExtra(ARG_TODO_ID, NO_ID)
        if (todoId == NO_ID) {
            todoId = null
        }

        presenter = lastCustomNonConfigurationInstance as? TodoDetailsPresenter
            ?: presenterProvider.create(todoId).also { it.start() }

        setupUi()
    }

    override fun onStart() {
        super.onStart()
        presenter.states.onEach { state ->
            if (state.saved) {
                onBackPressed()
                return@onEach
            }

            val todo = state.todo
            if (binding.text.text.toString() != todo.title) {
                binding.text.setText(todo.title)
            }
            adapter.setSelected(todo.periodUnit, todo.periodValue)

            val actionView = binding.toolbar.menu.findItem(R.id.done).actionView
            actionView.isEnabled = state.saveEnabled
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

    override fun onRetainCustomNonConfigurationInstance() = presenter

    private fun setupUi() {
        binding.periodsRecyclerView.layoutManager = LinearLayoutManager(this)
        binding.periodsRecyclerView.itemAnimator = null
        binding.periodsRecyclerView.adapter = adapter
        binding.periodsRecyclerView.addItemDecoration(VerticalSpacingDecoration(this, R.dimen.task_details_period_spacing))
        adapter.items = PeriodUnit.allPeriods()

        binding.toolbar.setNavigationOnClickListener { onBackPressed() }
        binding.toolbar.menu.findItem(R.id.done).actionView.setOnClickListener {
            presenter.events.offer(TodoDetailsPresenter.Event.Save)
        }

        binding.text.doOnTextChanged { text, _, _, _ ->
            val event = TodoDetailsPresenter.Event.ChangeTitle(text?.toString())
            presenter.events.offer(event)
        }
    }

    private fun showCountChooser() {
        val picker = PeriodPickerFragment.newInstance(1)
        picker.pickerListener = { count ->
            val event = TodoDetailsPresenter.Event.ChangePeriod(count)
            presenter.events.offer(event)
        }
        picker.show(supportFragmentManager, PeriodPickerFragment.TAG)
    }

    companion object {
        private const val ARG_TODO_ID = "todo_id"
        private const val NO_ID = -1L

        fun buildIntent(context: Context, todoId: Long?) = Intent(context, TodoDetailsActivity::class.java).apply {
            putExtra(ARG_TODO_ID, todoId ?: NO_ID)
        }
    }
}