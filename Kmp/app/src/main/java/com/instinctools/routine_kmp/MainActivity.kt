package com.instinctools.routine_kmp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
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

        val databaseProvider = AndroidDatabaseProvider(applicationContext)
        val todoStore = SqlDelightTodoStore(databaseProvider.database())

        presenter = TodoListPresenter(todoStore = todoStore)
        presenter.start()

        presenter.states.onEach { state ->
            binding.helloText.text = "Database have ${state.items.count()} items"
        }
            .launchIn(scope)
    }

    override fun onDestroy() {
        super.onDestroy()
        presenter.stop()
        scope.cancelChildren()
    }
}