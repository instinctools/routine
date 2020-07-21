package com.instinctools.routine_kmp.ui.list.adapter

import android.graphics.drawable.GradientDrawable
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.databinding.ItemTodoKmpBinding
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.color.toPlatformColor
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel
import java.lang.Math.abs

class TodosViewHolder(private val binding: ItemTodoKmpBinding) : RecyclerView.ViewHolder(binding.root) {

    var item: TodoListUiModel? = null

    fun bind(item: TodoListUiModel) {
        this.item = item
        binding.title.text = item.todo.title

        val periodValue = item.todo.periodValue
        binding.periodStr.text = when (item.todo.periodUnit) {
            PeriodUnit.DAY -> {
                when (periodValue) {
                    1 -> "Every day"
                    else -> "Every $periodValue days"
                }
            }
            PeriodUnit.WEEK -> {
                when (periodValue) {
                    1 -> "Once a week"
                    else -> "Every $periodValue weeks"
                }
            }
            PeriodUnit.MONTH -> {
                when (periodValue) {
                    1 -> "Once a month"
                    else -> "Every $periodValue months"
                }
            }
            PeriodUnit.YEAR -> {
                when (periodValue) {
                    1 -> "Once a year"
                    else -> "Every $periodValue years"
                }
            }
        }

        binding.targetDate.text = when {
            item.daysLeft == -1 -> "Yesterday"
            item.daysLeft < -1 && item.daysLeft > -7 -> "${abs(item.daysLeft)} days ago"
            item.daysLeft == -7 -> "1 week ago"
            item.daysLeft < -7 -> "Expired"

            item.daysLeft == 0 -> "Today"
            item.daysLeft == 1 -> "Tomorrow"
            item.daysLeft < 7 -> "${item.daysLeft} days left"
            item.daysLeft == 7 -> "1 week left"
            else -> null
        }

        val drawable = binding.root.background.mutate() as GradientDrawable
        drawable.setColor(item.color.toPlatformColor())
    }
}

class EmptyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)
