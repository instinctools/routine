package com.instinctools.routine_kmp.list.adapter

import android.content.Intent
import android.graphics.drawable.GradientDrawable
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.databinding.ItemTodoBinding
import com.instinctools.routine_kmp.details.DetailsActivity
import com.instinctools.routine_kmp.model.color.toPlatformColor
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel

class TodosViewHolder(private val binding: ItemTodoBinding) : RecyclerView.ViewHolder(binding.root) {

    var item: TodoListUiModel? = null

    init {
        binding.root.setOnClickListener {
            val item = item ?: return@setOnClickListener
            val intent = Intent(binding.root.context, DetailsActivity::class.java)
            intent.putExtra("EXTRA_ID", item.todo.id)
            binding.root.context.startActivity(intent)
        }
    }

    fun bind(item: TodoListUiModel) {
        this.item = item
        binding.title.text = item.todo.title
        binding.periodStr.text = item.todo.periodUnit.name
        binding.targetDate.text = item.todo.nextTimestamp.toString()

        val drawable = binding.root.background.mutate() as GradientDrawable
        drawable.setColor(item.color.toPlatformColor())
    }
}

class EmptyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)
