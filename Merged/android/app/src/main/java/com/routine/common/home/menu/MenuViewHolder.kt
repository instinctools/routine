package com.routine.common.home.menu

import android.graphics.Typeface
import androidx.recyclerview.widget.RecyclerView
import com.routine.databinding.ItemMenuBinding

class MenuViewHolder(private val binding: ItemMenuBinding, val menuClicks: MenuClicksImpl) :
        RecyclerView.ViewHolder(binding.root),
        MenuClicks by menuClicks {

    fun bind(menuData: MenuData.SimpleMenu) {
        menuClicks.menu = menuData.menu
        binding.icon.setImageResource(menuData.menu.icon ?: 0)
        binding.title.setText(menuData.menu.title)
        binding.title.setTypeface(null, if (menuData.isSelected) {
            Typeface.BOLD
        } else {
            Typeface.NORMAL
        })
    }
}
