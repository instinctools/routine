package com.routine.common.home

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.routine.R
import com.routine.databinding.ItemMenuBinding
import com.routine.databinding.ItemMenuTechnologyBinding

const val ITEM_HEADER = 0
const val ITEM_TECHNOLOGY = 1
const val ITEM_MENU = 2

class MenuAdapter : ListAdapter<Menu, RecyclerView.ViewHolder>(MenuDiff) {

    override fun getItemViewType(position: Int): Int {
        return if (position == 0) {
            ITEM_HEADER
        } else {
            val item = getItem(position - 1)
            if (item == Menu.TECHNOLOGY) ITEM_TECHNOLOGY else ITEM_MENU
        }
    }

    override fun getItemCount(): Int {
        return super.getItemCount() + 1
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        if (position == 0) return
        val item = getItem(position - 1)
        if (item != Menu.TECHNOLOGY && holder is MenuViewHolder){
            holder.bind(item)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        val item = if (viewType == ITEM_HEADER) {
            R.layout.item_menu_header
        } else if (viewType == ITEM_TECHNOLOGY) {
            R.layout.item_menu_technology
        } else {
            R.layout.item_menu
        }
        val layout = LayoutInflater.from(parent.context).inflate(item, parent, false)

        return if (viewType == ITEM_HEADER) {
            object : RecyclerView.ViewHolder(layout) {}
        } else if (viewType == ITEM_TECHNOLOGY) {
            TechnologyViewHolder(ItemMenuTechnologyBinding.bind(layout))
        } else {
            MenuViewHolder(ItemMenuBinding.bind(layout))
        }
    }
}

object MenuDiff : DiffUtil.ItemCallback<Menu>() {
    override fun areItemsTheSame(oldItem: Menu, newItem: Menu) = oldItem == newItem

    override fun areContentsTheSame(oldItem: Menu, newItem: Menu) = oldItem == newItem
}
