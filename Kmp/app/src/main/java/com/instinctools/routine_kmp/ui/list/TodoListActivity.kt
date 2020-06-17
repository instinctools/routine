package com.instinctools.routine_kmp.ui.list

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.SimpleItemAnimator
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ActivityTodosBinding
import com.instinctools.routine_kmp.ui.details.TodoDetailsActivity
import com.instinctools.routine_kmp.ui.list.adapter.TodosAdapter
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel
import com.instinctools.routine_kmp.util.appComponent
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject
import javax.inject.Provider

class TodoListActivity : AppCompatActivity() {

    private lateinit var binding: ActivityTodosBinding

    @Inject lateinit var presenterProvider: Provider<TodoListPresenter>

    private lateinit var presenter: TodoListPresenter
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    private val adapter = TodosAdapter { _, item ->
        val intent = TodoDetailsActivity.buildIntent(this, item.todo.id)
        startActivity(intent)
    }

    private val swipeActionsCallback = object : SwipeActionsCallback {
        override fun onLeftActivated(item: TodoListUiModel) {
            onResetTodoSelected(item)
        }

        override fun onRightActivated(item: TodoListUiModel) {
            onDeleteTodoSelected(item)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityTodosBinding.inflate(layoutInflater)
        setContentView(binding.root)

        appComponent.inject(this)

        presenter = lastCustomNonConfigurationInstance as? TodoListPresenter
            ?: presenterProvider.get().also { it.start() }

        setupUi()
    }

    @ExperimentalStdlibApi
    override fun onStart() {
        super.onStart()
        presenter.states.onEach { state ->
            val mergedItems = buildList {
                addAll(state.expiredTodos)
                if (state.expiredTodos.isNotEmpty()) {
                    add(Unit)
                }
                addAll(state.futureTodos)
            }
            binding.emptyView.visibility = if (mergedItems.isEmpty()) View.VISIBLE else View.GONE
            adapter.submitList(mergedItems)

            binding.swipeToRefresh.isRefreshing = state.refreshing
        }
            .launchIn(scope)
    }

    override fun onStop() {
        super.onStop()
        scope.cancelChildren()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (!isChangingConfigurations) {
            presenter.stop()
        }
    }

    override fun onRetainCustomNonConfigurationInstance() = presenter

    private fun setupUi() {
        binding.content.layoutManager = LinearLayoutManager(this)
        binding.content.adapter = adapter

        val swipeCallback = SwipeCallback(this, swipeActionsCallback)
        ItemTouchHelper(swipeCallback).attachToRecyclerView(binding.content)
        val animator = binding.content.itemAnimator as? SimpleItemAnimator
        animator?.supportsChangeAnimations = false

        binding.toolbar.setOnMenuItemClickListener {
            startActivity(Intent(this, TodoDetailsActivity::class.java))
            true
        }

        binding.swipeToRefresh.setOnRefreshListener {
            presenter.events.offer(TodoListPresenter.Event.Refresh)
        }
    }

    private fun onResetTodoSelected(item: TodoListUiModel) {
        val event = TodoListPresenter.Event.Reset(item.todo.id)
        presenter.events.offer(event)
    }

    private fun onDeleteTodoSelected(item: TodoListUiModel) {
        AlertDialog.Builder(this)
            .setMessage(R.string.todos_delete_message)
            .setPositiveButton(R.string.todos_delete_ok) { _, _ ->
                val event = TodoListPresenter.Event.Delete(item.todo.id)
                presenter.events.offer(event)
            }
            .setNegativeButton(R.string.todos_delete_cancel, null)
            .show()
    }
}