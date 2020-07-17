package com.instinctools.routine_kmp.ui.details

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.core.widget.doOnTextChanged
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.snackbar.Snackbar
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ActivityDetailsBinding
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.ui.RetainPresenterActivity
import com.instinctools.routine_kmp.ui.details.adapter.PeriodsAdapter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenterFactory
import com.instinctools.routine_kmp.ui.widget.IosLikeToggle
import com.instinctools.routine_kmp.ui.widget.VerticalSpacingDecoration
import com.instinctools.routine_kmp.util.appComponent
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject

class TodoDetailsActivity : RetainPresenterActivity<TodoDetailsPresenter>() {

    private lateinit var binding: ActivityDetailsBinding

    @Inject lateinit var presenterProvider: TodoDetailsPresenterFactory

    override lateinit var presenter: TodoDetailsPresenter
    override val presenterCreator: () -> TodoDetailsPresenter = {
        var todoId: String? = intent.getStringExtra(ARG_TODO_ID)
        if (todoId.isNullOrEmpty()) {
            todoId = null
        }
        presenterProvider.create(todoId)
    }

    private val adapter = PeriodsAdapter(
        selectionListener = { _, item ->
            presenter.events.offer(TodoDetailsPresenter.Event.ChangePeriodUnit(item.unit))
        },
        countChooserListener = { position, item ->
            presenter.events.offer(TodoDetailsPresenter.Event.ChangePeriodUnit(item.unit))
            showCountChooser(item.count)
        }
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDetailsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        appComponent.inject(this)

        createPresenter()
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
            if (binding.titleInput.text.toString() != todo.title) {
                binding.titleInput.setText(todo.title)
            }

            adapter.submitList(state.periods)
            adapter.setSelected(todo.periodUnit)

            val actionView = binding.toolbar.menu.findItem(R.id.done).actionView
            actionView.isEnabled = state.saveEnabled

            binding.periodStrategyToggle.setSelected(todo.periodStrategy)

            if (state.saveError?.unhandled == true) {
                Snackbar.make(binding.root, R.string.task_details_error_save, Snackbar.LENGTH_SHORT).show()
                state.saveError?.consume()
            }
        }
            .launchIn(scope)
    }

    private fun setupUi() {
        binding.periodsRecyclerView.layoutManager = LinearLayoutManager(this)
        binding.periodsRecyclerView.itemAnimator = null
        binding.periodsRecyclerView.adapter = adapter
        binding.periodsRecyclerView.addItemDecoration(VerticalSpacingDecoration(this, R.dimen.task_details_period_spacing))

        binding.toolbar.setNavigationOnClickListener { onBackPressed() }
        binding.toolbar.menu.findItem(R.id.done).actionView.setOnClickListener {
            presenter.events.offer(TodoDetailsPresenter.Event.Save)
        }

        binding.titleInput.doOnTextChanged { text, _, _, _ ->
            val event = TodoDetailsPresenter.Event.ChangeTitle(text?.toString())
            presenter.events.offer(event)
        }

        binding.periodStrategyToggle.settings = IosLikeToggle.Settings(
            IosLikeToggle.Item(PeriodResetStrategy.FromNow, resources.getString(R.string.reset_period_strategy_from_now)),
            IosLikeToggle.Item(PeriodResetStrategy.FromNextEvent, resources.getString(R.string.reset_period_strategy_from_next_event))
        ) { item ->
            val strategy = item as? PeriodResetStrategy ?: return@Settings
            val event = TodoDetailsPresenter.Event.ChangePeriodStrategy(strategy)
            presenter.events.offer(event)
        }
    }

    private fun showCountChooser(initialCount: Int) {
        val picker = PeriodPickerFragment.newInstance(initialCount)
        picker.pickerListener = { count ->
            val event = TodoDetailsPresenter.Event.ChangePeriod(count)
            presenter.events.offer(event)
        }
        picker.show(supportFragmentManager, PeriodPickerFragment.TAG)
    }

    companion object {
        private const val ARG_TODO_ID = "todo_id"
        private const val NO_ID = ""

        fun buildIntent(context: Context, todoId: String?) = Intent(context, TodoDetailsActivity::class.java).apply {
            putExtra(ARG_TODO_ID, todoId ?: NO_ID)
        }
    }
}