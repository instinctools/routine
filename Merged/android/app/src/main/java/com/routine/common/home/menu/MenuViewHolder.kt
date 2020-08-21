package com.routine.common.home.menu

import androidx.recyclerview.widget.RecyclerView
import com.routine.databinding.ItemMenuBinding

class MenuViewHolder(private val binding: ItemMenuBinding, val menuClicks: MenuClicksImpl) :
        RecyclerView.ViewHolder(binding.root),
        MenuClicks by menuClicks {

    fun bind(menu: Menu) {
        menuClicks.menu = menu
        binding.icon.setImageResource(menu.icon ?: 0)
        binding.title.setText(menu.title)
    }
}
