package com.instinctools.routine_kmp.ui.list.adapter

import android.graphics.drawable.GradientDrawable
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.databinding.ItemTodoBinding
import com.instinctools.routine_kmp.model.color.toPlatformColor
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel

class TodosViewHolder(private val binding: ItemTodoBinding) : RecyclerView.ViewHolder(binding.root) {

    var item: TodoListUiModel? = null

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
