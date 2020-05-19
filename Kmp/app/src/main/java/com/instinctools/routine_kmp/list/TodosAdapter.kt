package com.instinctools.routine_kmp.list

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ItemTodoBinding
import com.instinctools.routine_kmp.model.Todo

class TodosAdapter : ListAdapter<Any, RecyclerView.ViewHolder>(TodoDiff) {

    companion object {
        const val TYPE_TODO = 0
        const val TYPE_SEPARATOR = 1
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        return if (viewType == TYPE_TODO) {
            TodosViewHolder(ItemTodoBinding.inflate(inflater, parent, false))
        } else {
            val view = inflater.inflate(R.layout.item_separator, parent, false)
            EmptyViewHolder(view)
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val item = getItem(position)
        if (item is Todo) {
            (holder as TodosViewHolder).bind(item)
        }
    }

    override fun getItemViewType(position: Int): Int {
        val item = getItem(position)
        return if (item is Todo) {
            TYPE_TODO
        } else {
            TYPE_SEPARATOR
        }
    }
}

private object TodoDiff : DiffUtil.ItemCallback<Any>() {

    override fun areItemsTheSame(oldItem: Any, newItem: Any): Boolean {
        if (oldItem is Todo && newItem is Todo) {
            return oldItem.id == newItem.id
        }
        return true
    }

    @SuppressLint("DiffUtilEquals")
    override fun areContentsTheSame(oldItem: Any, newItem: Any): Boolean {
        if (oldItem is Todo && newItem is Todo) {
            return oldItem == newItem
        }
        return true
    }
}