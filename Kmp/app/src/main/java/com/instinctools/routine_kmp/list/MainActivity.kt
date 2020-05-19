package com.instinctools.routine_kmp.list

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.SimpleItemAnimator
import com.instinctools.routine_kmp.details.DetailsActivity
import com.instinctools.routine_kmp.data.AndroidDatabaseProvider
import com.instinctools.routine_kmp.data.SqlDelightTodoStore
import com.instinctools.routine_kmp.databinding.ActivityMainBinding
import com.instinctools.routine_kmp.ui.TodoListPresenter
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class MainActivity : AppCompatActivity() {

    private lateinit var presenter: TodoListPresenter

    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.toolbar.setOnMenuItemClickListener {
            startActivity(Intent(this, DetailsActivity::class.java))
            true
        }

        ItemTouchHelper(SwipeCallback(this)).attachToRecyclerView(binding.content)
        val animator = binding.content.itemAnimator
        if (animator is SimpleItemAnimator) {
            animator.supportsChangeAnimations = false
        }

        val adapter = TodosAdapter()
        binding.content.layoutManager = LinearLayoutManager(this)
        binding.content.adapter = adapter

        val databaseProvider = AndroidDatabaseProvider(applicationContext)
        val todoStore = SqlDelightTodoStore(databaseProvider.database())

        presenter = TodoListPresenter(todoStore = todoStore)
        presenter.start()

        presenter.states.onEach { state ->
            Log.d("asd", "items received ${state.items.count()}")
            adapter.submitList(state.items)
        }
            .launchIn(scope)
    }

    override fun onDestroy() {
        super.onDestroy()
        presenter.stop()
        scope.cancelChildren()
    }
}