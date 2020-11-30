package com.instinctools.routine_kmp.ui.list

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AlertDialog
import androidx.core.view.isVisible
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.SimpleItemAnimator
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.FragmentTodosListBinding
import com.instinctools.routine_kmp.ui.BaseFragment
import com.instinctools.routine_kmp.ui.details.TodoDetailsFragment
import com.instinctools.routine_kmp.ui.list.adapter.TodosAdapter
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel
import com.instinctools.routine_kmp.util.*
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import timber.log.Timber

class TodoListFragment : BaseFragment(R.layout.fragment_todos_list) {

    private val binding by viewBinding(FragmentTodosListBinding::bind)
    private val container by presenterContainer { injector.todoListPresenter }
    private val presenter get() = container.presenter

    @ExperimentalStdlibApi
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.swipeToRefresh.setOnRefreshListener { presenter.sendAction(TodoListPresenter.Action.Refresh) }
        binding.toolbar.setOnMenuItemClickListener {
            rootNavigator.goto(TodoDetailsFragment.newInstance())
            true
        }

        val adapter = TodosAdapter { _, item -> rootNavigator.goto(TodoDetailsFragment.newInstance(item.todo.id)) }
        val swipeActionsCallback = object : SwipeActionsCallback {
            override fun onLeftActivated(item: TodoListUiModel) {
                presenter.sendAction(TodoListPresenter.Action.ResetTask(item.todo.id))
            }

            override fun onRightActivated(item: TodoListUiModel) {
                showDeleteTaskConfirmation(item)
            }
        }
        binding.todosRecycler.layoutManager = LinearLayoutManager(view.context)
        binding.todosRecycler.adapter = adapter

        val swipeCallback = SwipeCallback(view.context, swipeActionsCallback)
        ItemTouchHelper(swipeCallback).attachToRecyclerView(binding.todosRecycler)
        val animator = binding.todosRecycler.itemAnimator as? SimpleItemAnimator
        animator?.supportsChangeAnimations = false

        presenter.states.onEach { state: TodoListPresenter.State ->
            val mergedItems = buildList {
                addAll(state.expiredTodos)
                if (state.expiredTodos.isNotEmpty()) {
                    add(Unit)
                }
                addAll(state.futureTodos)
            }
            adapter.submitList(mergedItems)

            binding.emptyView.isVisible = mergedItems.isEmpty()
            binding.swipeToRefresh.isRefreshing = state.progress

            state.resetDone.consumeOneTimeEvent { binding.root.snackbarOf(R.string.tasks_reset_success) }
            state.deleteDone.consumeOneTimeEvent { binding.root.snackbarOf(R.string.tasks_delete_success) }

            state.refreshError.consumeOneTimeEvent {
                Timber.e(it, "Failed to refresh todos")
                binding.root.snackbarOf(R.string.tasks_error_refresh)
            }
            state.deleteError.consumeOneTimeEvent {
                Timber.e(it, "Failed to delete todo")
                binding.root.snackbarOf(R.string.tasks_error_delete)
            }
            state.resetError.consumeOneTimeEvent {
                Timber.e(it, "Failed to reset todo")
                binding.root.snackbarOf(R.string.tasks_error_reset)
            }
        }
            .launchIn(viewScope)
    }

    private fun showDeleteTaskConfirmation(item: TodoListUiModel) {
        AlertDialog.Builder(requireContext())
            .setMessage(R.string.todos_delete_message)
            .setPositiveButton(R.string.todos_delete_ok) { _, _ ->
                presenter.sendAction(TodoListPresenter.Action.DeleteTask(item.todo.id))
            }
            .setNegativeButton(R.string.todos_delete_cancel, null)
            .show()
    }

    companion object {
        fun newInstance() = TodoListFragment()
    }
}