package com.routine.common.ui.home.menu

import android.graphics.Typeface
import androidx.recyclerview.widget.RecyclerView
import com.routine.databinding.ItemMenuTechnologyBinding

class TechnologyViewHolder(val binding: ItemMenuTechnologyBinding, val menuClicks: MenuTechnologyClicks) :
        RecyclerView.ViewHolder(binding.root), MenuClicks by menuClicks {

    private val views = arrayOf(binding.technologyAndroidNative,
            binding.technologyReactNative,
            binding.technologyFlutter,
            binding.technologyKmp)

    fun bind(menuTechnology: MenuData.MenuTechnology) {
        menuClicks.selectedMenu = menuTechnology.selectedSubMenu
        if (!menuTechnology.expanded) {
            binding.root.transitionToStart()
        } else {
            binding.root.transitionToEnd()
        }

        binding.title.setTypeface(null, if (menuTechnology.isSelected) {
            Typeface.BOLD
        } else {
            Typeface.NORMAL
        })

        views.forEach { it.setTypeface(null, Typeface.NORMAL) }

        val view = when (menuTechnology.selectedSubMenu) {
            Menu.ANDROID_NATIVE -> binding.technologyAndroidNative
            Menu.REACT_NATIVE -> binding.technologyReactNative
            Menu.FLUTTER -> binding.technologyFlutter
            Menu.KMP -> binding.technologyKmp
            else -> null
        }

        view?.setTypeface(null, Typeface.BOLD)
    }
}
