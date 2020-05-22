package com.instinctools.routine_kmp.list

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.SimpleItemAnimator
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.data.AndroidDatabaseProvider
import com.instinctools.routine_kmp.data.database.SqlTodoStore
import com.instinctools.routine_kmp.databinding.ActivityMainBinding
import com.instinctools.routine_kmp.details.DetailsActivity
import com.instinctools.routine_kmp.list.adapter.TodosAdapter
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class MainActivity : AppCompatActivity() {

    private lateinit var presenter: TodoListPresenter
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    private val adapter = TodosAdapter()

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
        val binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupUi(binding)

        val databaseProvider = AndroidDatabaseProvider(applicationContext)
        val todoStore = SqlTodoStore(databaseProvider.database())

        presenter = TodoListPresenter(todoStore = todoStore)
        presenter.start()
    }

    @ExperimentalStdlibApi
    override fun onStart() {
        super.onStart()
        presenter.states.onEach { state ->
            val mergedItems = buildList {
                addAll(state.expiredTodos)
                add(Unit)
                addAll(state.futureTodos)
            }
            adapter.submitList(mergedItems)
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

    private fun setupUi(binding: ActivityMainBinding) {
        binding.content.layoutManager = LinearLayoutManager(this)
        binding.content.adapter = adapter

        val swipeCallback = SwipeCallback(this, swipeActionsCallback)
        ItemTouchHelper(swipeCallback).attachToRecyclerView(binding.content)
        val animator = binding.content.itemAnimator as? SimpleItemAnimator
        animator?.supportsChangeAnimations = false

        binding.toolbar.setOnMenuItemClickListener {
            startActivity(Intent(this, DetailsActivity::class.java))
            true
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