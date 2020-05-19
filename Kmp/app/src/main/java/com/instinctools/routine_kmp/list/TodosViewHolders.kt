package com.instinctools.routine_kmp.list

import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.DetailsActivity
import com.instinctools.routine_kmp.databinding.ItemTodoBinding
import com.instinctools.routine_kmp.model.Todo

class TodosViewHolder(private val binding: ItemTodoBinding) : RecyclerView.ViewHolder(binding.root) {

    var todo: Todo? = null

    init {
        binding.root.setOnClickListener {
            todo?.let {
                val intent = Intent(binding.root.context, DetailsActivity::class.java)
                intent.putExtra("EXTRA_ID", it.id)
                binding.root.context.startActivity(intent)
            }
        }
    }

    fun bind(todo: Todo) {
        this.todo = todo
        binding.title.text = todo.title
        binding.periodStr.text = todo.periodType.name
        binding.targetDate.text = todo.nextTimestamp.toString()

        val drawable = binding.root.background.mutate() as GradientDrawable
        drawable.setColor(Color.RED)
    }
}

class EmptyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)
