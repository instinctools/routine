package com.instinctools.routine_kmp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.instinctools.routine_kmp.data.AndroidDatabaseProvider
import com.instinctools.routine_kmp.data.SqlDelightTodoStore
import com.instinctools.routine_kmp.databinding.MainBinding
import com.instinctools.routine_kmp.ui.TodoListPresenter
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.*

class MainActivity : AppCompatActivity() {

    private lateinit var presenter: TodoListPresenter

    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = MainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val databaseProvider = AndroidDatabaseProvider(applicationContext)
        val todoStore = SqlDelightTodoStore(databaseProvider.database())

        presenter = TodoListPresenter(todoStore = todoStore)
        presenter.start()

        scope.launch {
            for (state in presenter.states) {
                binding.helloText.text = "Database have ${state.items.count()} items"
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        presenter.stop()
        scope.cancelChildren()
    }
}