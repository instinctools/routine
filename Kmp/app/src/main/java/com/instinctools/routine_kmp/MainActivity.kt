package com.instinctools.routine_kmp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.instinctools.routine_kmp.data.AndroidDatabaseProvider
import com.instinctools.routine_kmp.data.SqlDelightTodoStore
import com.instinctools.routine_kmp.databinding.MainBinding
import com.instinctools.routine_kmp.ui.TodoListPresenter

class MainActivity : AppCompatActivity() {

    private lateinit var presenter: TodoListPresenter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = MainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val databaseProvider = AndroidDatabaseProvider(applicationContext)
        val todoStore = SqlDelightTodoStore(databaseProvider.database())
        presenter = TodoListPresenter(
            uiUpdater = { todos ->
                binding.helloText.text = "Database have ${todos.count()} items"
            },
            todoStore = todoStore
        )
        presenter.start()
    }

    override fun onDestroy() {
        super.onDestroy()
        presenter.stop()
    }
}