package com.instinctools.routine_kmp.list.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ItemTodoBinding
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel

class TodosAdapter : ListAdapter<Any, RecyclerView.ViewHolder>(TodoDiff) {

    companion object {
        const val TYPE_TODO = 0
        const val TYPE_SEPARATOR = 1
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        return when (viewType) {
            TYPE_TODO -> TodosViewHolder(ItemTodoBinding.inflate(inflater, parent, false))
            TYPE_SEPARATOR -> {
                val view = inflater.inflate(R.layout.item_separator, parent, false)
                EmptyViewHolder(view)
            }
            else -> throw IllegalStateException("Couldn't create view for view type $viewType")
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val item = getItem(position)
        if (item is TodoListUiModel) {
            (holder as TodosViewHolder).bind(item)
        }
    }

    override fun getItemViewType(position: Int) = when (val item = getItem(position)) {
        is TodoListUiModel -> TYPE_TODO
        is Unit -> TYPE_SEPARATOR
        else -> throw IllegalStateException("Failed to define item view type at $position, item=$item")
    }
}

private object TodoDiff : DiffUtil.ItemCallback<Any>() {

    override fun areItemsTheSame(oldItem: Any, newItem: Any): Boolean {
        if (oldItem is TodoListUiModel && newItem is TodoListUiModel) {
            return oldItem.todo.id == newItem.todo.id
        }
        return true
    }

    @SuppressLint("DiffUtilEquals")
    override fun areContentsTheSame(oldItem: Any, newItem: Any): Boolean {
        if (oldItem is TodoListUiModel && newItem is TodoListUiModel) {
            return oldItem == newItem
        }
        return true
    }
}