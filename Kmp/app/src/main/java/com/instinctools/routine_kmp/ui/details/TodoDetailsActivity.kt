package com.instinctools.routine_kmp.ui.details

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.core.view.isVisible
import androidx.core.widget.doOnTextChanged
import androidx.recyclerview.widget.LinearLayoutManager
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ActivityDetailsBinding
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.ui.RetainPresenterActivity
import com.instinctools.routine_kmp.ui.details.adapter.PeriodsAdapter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter.*
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenterFactory
import com.instinctools.routine_kmp.ui.widget.IosLikeToggle
import com.instinctools.routine_kmp.ui.widget.VerticalSpacingDecoration
import com.instinctools.routine_kmp.util.appComponent
import com.instinctools.routine_kmp.util.consumeOneTimeEvent
import com.instinctools.routine_kmp.util.setTextIfChanged
import com.instinctools.routine_kmp.util.snackbarOf
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject

class TodoDetailsActivity : RetainPresenterActivity<TodoDetailsPresenter>() {

    private lateinit var binding: ActivityDetailsBinding

    @Inject lateinit var presenterProvider: TodoDetailsPresenterFactory

    override lateinit var presenter: TodoDetailsPresenter
    override val presenterCreator: () -> TodoDetailsPresenter = {
        val todoId = intent.getStringExtra(ARG_TODO_ID)?.ifEmpty { null }
        presenterProvider.create(todoId)
    }

    private val adapter = PeriodsAdapter(
        selectionListener = { _, item ->
            presenter.sendAction(Action.ChangePeriodUnit(item.unit))
        },
        countChooserListener = { _, item ->
            presenter.sendAction(Action.ChangePeriodUnit(item.unit))
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
        val actionView by lazy { binding.toolbar.menu.findItem(R.id.done).actionView }
        presenter.states.onEach { state ->
            state.saved.consumeOneTimeEvent {
                onBackPressed()
                return@onEach
            }

            actionView.isEnabled = state.saveEnabled
            binding.progress.isVisible = state.progress

            val todo = state.todo
            binding.titleInput.setTextIfChanged(todo.title)
            binding.periodStrategyToggle.setSelected(todo.periodStrategy)

            adapter.submitList(state.periods)
            adapter.setSelected(todo.periodUnit)

            state.saveError.consumeOneTimeEvent { binding.root.snackbarOf(R.string.task_details_error_save) }
            state.loadingError.consumeOneTimeEvent { binding.root.snackbarOf(R.string.task_details_error_load) }
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
            presenter.sendAction(Action.SaveTask)
        }

        binding.titleInput.doOnTextChanged { text, _, _, _ ->
            presenter.sendAction(Action.ChangeTitle(text?.toString()))
        }

        binding.periodStrategyToggle.settings = IosLikeToggle.Settings(
            IosLikeToggle.Item(PeriodResetStrategy.FromNow, resources.getString(R.string.reset_period_strategy_from_now)),
            IosLikeToggle.Item(PeriodResetStrategy.FromNextEvent, resources.getString(R.string.reset_period_strategy_from_next_event))
        ) { item ->
            val strategy = item as? PeriodResetStrategy ?: return@Settings
            presenter.sendAction(Action.ChangePeriodStrategy(strategy))
        }
    }

    private fun showCountChooser(initialCount: Int) {
        val picker = PeriodPickerFragment.newInstance(initialCount)
        picker.pickerListener = { count ->
            presenter.sendAction(Action.ChangePeriod(count))
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