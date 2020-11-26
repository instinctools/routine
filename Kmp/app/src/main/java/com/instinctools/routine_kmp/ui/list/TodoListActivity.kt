package com.instinctools.routine_kmp.ui.list

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AlertDialog
import androidx.core.view.isVisible
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.SimpleItemAnimator
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ActivityTodosBinding
import com.instinctools.routine_kmp.ui.RetainPresenterActivity
import com.instinctools.routine_kmp.ui.details.TodoDetailsActivity
import com.instinctools.routine_kmp.ui.list.adapter.TodosAdapter
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter.Action
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter.State
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel
import com.instinctools.routine_kmp.util.appComponent
import com.instinctools.routine_kmp.util.consumeOneTimeEvent
import com.instinctools.routine_kmp.util.snackbarOf
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject
import javax.inject.Provider

class TodoListActivity : RetainPresenterActivity<TodoListPresenter>() {

    private lateinit var binding: ActivityTodosBinding

    @Inject lateinit var presenterProvider: Provider<TodoListPresenter>

    override lateinit var presenter: TodoListPresenter
    override val presenterCreator: () -> TodoListPresenter = {
        presenterProvider.get()
    }

    private val adapter = TodosAdapter { _, item ->
        val intent = TodoDetailsActivity.buildIntent(this, item.todo.id)
        startActivity(intent)
    }

    private val swipeActionsCallback = object : SwipeActionsCallback {
        override fun onLeftActivated(item: TodoListUiModel) {
            presenter.sendAction(Action.ResetTask(item.todo.id))
        }

        override fun onRightActivated(item: TodoListUiModel) {
            showDeleteTaskConfirmation(item)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityTodosBinding.inflate(layoutInflater)
        setContentView(binding.root)

        appComponent.inject(this)
        createPresenter()

        binding.swipeToRefresh.setOnRefreshListener { presenter.sendAction(Action.Refresh) }
        binding.toolbar.setOnMenuItemClickListener {
            startActivity(Intent(this, TodoDetailsActivity::class.java))
            true
        }

        binding.todosRecycler.layoutManager = LinearLayoutManager(this)
        binding.todosRecycler.adapter = adapter

        val swipeCallback = SwipeCallback(this, swipeActionsCallback)
        ItemTouchHelper(swipeCallback).attachToRecyclerView(binding.todosRecycler)
        val animator = binding.todosRecycler.itemAnimator as? SimpleItemAnimator
        animator?.supportsChangeAnimations = false
    }

    @ExperimentalStdlibApi
    override fun onStart() {
        super.onStart()
        presenter.states.onEach { state: State ->
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

            state.refreshError.consumeOneTimeEvent { binding.root.snackbarOf(R.string.tasks_error_refresh) }
            state.deleteError.consumeOneTimeEvent { binding.root.snackbarOf(R.string.tasks_error_delete) }
            state.resetError.consumeOneTimeEvent { binding.root.snackbarOf(R.string.tasks_error_reset) }
        }
            .launchIn(scope)
    }

    private fun showDeleteTaskConfirmation(item: TodoListUiModel) {
        AlertDialog.Builder(this)
            .setMessage(R.string.todos_delete_message)
            .setPositiveButton(R.string.todos_delete_ok) { _, _ ->
                presenter.sendAction(Action.DeleteTask(item.todo.id))
            }
            .setNegativeButton(R.string.todos_delete_cancel, null)
            .show()
    }

    companion object {
        fun buildIntent(context: Context) = Intent(context, TodoListActivity::class.java)
    }
}