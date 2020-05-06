package com.instinctools.routine_android

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_android.data.Todo
import com.instinctools.routine_android.databinding.ActivityMainBinding
import com.instinctools.routine_android.databinding.ItemTodoBinding
import kotlinx.android.synthetic.main.item_todo.view.*

class MainActivity : AppCompatActivity() {

    private val binding: ActivityMainBinding by viewBinding(ActivityMainBinding::inflate)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        binding.toolbar.setOnMenuItemClickListener {
            startActivity(Intent(this, DetailsActivity::class.java))
            true
        }

        val adapter = TodosAdapter()
        binding.content.adapter = adapter

        val list = mutableListOf<Todo>()
        for (i in 0..50) {
            list.add(Todo(i))
        }

        adapter.submitList(list)
    }

    private class TodosAdapter : ListAdapter<Todo, TodosViewHolder>(object : DiffUtil.ItemCallback<Todo>() {
        override fun areItemsTheSame(oldItem: Todo, newItem: Todo): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: Todo, newItem: Todo): Boolean {
            return oldItem == newItem
        }
    }) {
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TodosViewHolder {
            return TodosViewHolder(ItemTodoBinding.inflate(LayoutInflater.from(parent.context), parent, false))
        }

        override fun onBindViewHolder(holder: TodosViewHolder, position: Int) {
            holder.bind(getItem(position))
        }
    }

    private class TodosViewHolder(val binding: ItemTodoBinding) : RecyclerView.ViewHolder(binding.root) {

        fun bind(todo: Todo) {
            binding.title.text = todo.title
            binding.periodStr.text = todo.periodStr
            binding.periodDate.text = todo.periodDate
        }
    }
}
