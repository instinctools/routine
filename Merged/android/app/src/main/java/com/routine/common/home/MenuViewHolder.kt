package com.routine.common.home

import androidx.recyclerview.widget.RecyclerView
import com.routine.databinding.ItemMenuBinding

class MenuViewHolder(private val binding: ItemMenuBinding) : RecyclerView.ViewHolder(binding.root) {

    fun bind(menu: Menu) {
        binding.icon.setImageResource(menu.icon)
        binding.title.setText(menu.title)
    }
}
