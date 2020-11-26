package com.instinctools.routine_kmp.ui.details

import android.os.Bundle
import android.view.View
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.core.widget.doOnTextChanged
import androidx.recyclerview.widget.LinearLayoutManager
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.FragmentTodoDetailsBinding
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.ui.BaseFragment
import com.instinctools.routine_kmp.ui.details.adapter.PeriodsAdapter
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter.*
import com.instinctools.routine_kmp.ui.widget.IosLikeToggle
import com.instinctools.routine_kmp.ui.widget.VerticalSpacingDecoration
import com.instinctools.routine_kmp.util.*
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class TodoDetailsFragment : BaseFragment(R.layout.fragment_todo_details) {

    private val binding by viewBinding(FragmentTodoDetailsBinding::bind)
    private val container by presenterContainer { injector.todoDetailsPresenterFactory.create(todoId) }
    private val presenter get() = container.presenter

    private val todoId: String? by argument(ARG_TODO_ID)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.toolbar.setNavigationOnClickListener { rootNavigator.goBack() }
        val saveActionView = binding.toolbar.menu.findItem(R.id.done).actionView
        saveActionView.setOnClickListener { presenter.sendAction(Action.SaveTask) }

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

        val adapter = PeriodsAdapter(
            selectionListener = { _, item -> presenter.sendAction(Action.ChangePeriodUnit(item.unit)) },
            countChooserListener = { _, item ->
                presenter.sendAction(Action.ChangePeriodUnit(item.unit))
                showCountChooser(item.count)
            }
        )
        binding.periodsRecyclerView.layoutManager = LinearLayoutManager(view.context)
        binding.periodsRecyclerView.itemAnimator = null
        binding.periodsRecyclerView.adapter = adapter
        binding.periodsRecyclerView.addItemDecoration(VerticalSpacingDecoration(view.context, R.dimen.task_details_period_spacing))

        presenter.states.onEach { state: State ->
            state.saved.consumeOneTimeEvent {
                rootNavigator.goBack()
                return@onEach
            }

            saveActionView.isEnabled = state.saveEnabled
            binding.progress.isVisible = state.progress

            val todo = state.todo
            binding.titleInput.setTextIfChanged(todo.title)
            binding.periodStrategyToggle.setSelected(todo.periodStrategy)

            adapter.submitList(state.periods)
            adapter.setSelected(todo.periodUnit)

            state.saveError.consumeOneTimeEvent { binding.root.snackbarOf(R.string.task_details_error_save) }
            state.loadingError.consumeOneTimeEvent { binding.root.snackbarOf(R.string.task_details_error_load) }
        }
            .launchIn(viewScope)
    }

    private fun showCountChooser(initialCount: Int) {
        val picker = PeriodPickerFragment.newInstance(initialCount)
        picker.pickerListener = { count ->
            presenter.sendAction(Action.ChangePeriod(count))
        }
        picker.show(childFragmentManager, PeriodPickerFragment.TAG)
    }

    companion object {
        const val ARG_TODO_ID = "todo_id"

        fun newInstance(todoId: String? = null) = TodoDetailsFragment().apply {
            arguments = bundleOf(ARG_TODO_ID to todoId)
        }
    }
}