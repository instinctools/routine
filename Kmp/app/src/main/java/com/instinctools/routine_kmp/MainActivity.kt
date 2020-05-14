package com.instinctools.routine_kmp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.instinctools.routine_kmp.data.AndroidDatabaseProvider
import com.instinctools.routine_kmp.data.SqlDelightTodoStore
import com.instinctools.routine_kmp.databinding.MainBinding
import com.instinctools.routine_kmp.model.PeriodType
import com.instinctools.routine_kmp.model.Todo

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = MainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val databaseProvider = AndroidDatabaseProvider(applicationContext)
        val todoStore = SqlDelightTodoStore(databaseProvider.database())

        for (i in 0..10) {
            todoStore.insert(Todo(0, "Todo #$i", PeriodType.DAILY, 1, 0))
        }

        val todos = todoStore.getTodos()
        binding.helloText.text = todos.count().toString()
    }
}