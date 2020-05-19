package com.instinctools.routine_kmp.list

import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.databinding.ItemTodoBinding
import com.instinctools.routine_kmp.details.DetailsActivity
import com.instinctools.routine_kmp.ui.todo.TodoUiModel

class TodosViewHolder(private val binding: ItemTodoBinding) : RecyclerView.ViewHolder(binding.root) {

    var item: TodoUiModel? = null

    init {
        binding.root.setOnClickListener {
            val item = item ?: return@setOnClickListener
            val intent = Intent(binding.root.context, DetailsActivity::class.java)
            intent.putExtra("EXTRA_ID", item.todo.id)
            binding.root.context.startActivity(intent)
        }
    }

    fun bind(item: TodoUiModel) {
        this.item = item
        binding.title.text = item.todo.title
        binding.periodStr.text = item.todo.periodUnit.name
        binding.targetDate.text = item.todo.nextTimestamp.toString()

        val drawable = binding.root.background.mutate() as GradientDrawable
        drawable.setColor(Color.RED)
    }
}

class EmptyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)
