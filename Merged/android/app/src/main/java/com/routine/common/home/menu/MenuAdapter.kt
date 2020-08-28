package com.routine.common.home.menu

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.routine.R
import com.routine.common.launchIn
import com.routine.data.model.Event
import com.routine.databinding.ItemMenuBinding
import com.routine.databinding.ItemMenuTechnologyBinding
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow

const val ITEM_HEADER = 0
const val ITEM_TECHNOLOGY = 1
const val ITEM_MENU = 2

@ExperimentalCoroutinesApi
class MenuAdapter(private val coroutineScope: CoroutineScope) : ListAdapter<MenuData, RecyclerView.ViewHolder>(MenuDiff) {

    val clicksFlow = MutableStateFlow<Event<Menu>?>(null)

    override fun getItemViewType(position: Int): Int =
        when (getItem(position)) {
            is MenuData.HeaderMenu -> ITEM_HEADER
            is MenuData.SimpleMenu -> ITEM_MENU
            is MenuData.MenuTechnology -> ITEM_TECHNOLOGY
        }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val item = getItem(position)
        if (item is MenuData.SimpleMenu && holder is MenuViewHolder) {
            holder.bind(item.menu)
        } else if (item is MenuData.MenuTechnology && holder is TechnologyViewHolder) {
            holder.bind(item)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        val item = when (viewType) {
            ITEM_HEADER -> {
                R.layout.item_menu_header
            }
            ITEM_TECHNOLOGY -> {
                R.layout.item_menu_technology
            }
            else -> {
                R.layout.item_menu
            }
        }
        val layout = LayoutInflater.from(parent.context).inflate(item, parent, false)
        when (viewType) {
            ITEM_HEADER -> {
                return object : RecyclerView.ViewHolder(layout) {}
            }
            ITEM_TECHNOLOGY -> {
                val binding = ItemMenuTechnologyBinding.bind(layout)
                return TechnologyViewHolder(ItemMenuTechnologyBinding.bind(layout), MenuTechnologyClicks(binding).also { it.menuClicks().launchIn(coroutineScope, clicksFlow) })
            }
            ITEM_MENU -> {
                val binding = ItemMenuBinding.bind(layout)
                return MenuViewHolder(binding, MenuClicksImpl(binding.root).also { it.menuClicks().launchIn(coroutineScope, clicksFlow) })
            }
        }
        throw UnsupportedOperationException("Unknown viewType")
    }
}

object MenuDiff : DiffUtil.ItemCallback<MenuData>() {
    override fun areItemsTheSame(oldItem: MenuData, newItem: MenuData): Boolean =
        (oldItem is MenuData.HeaderMenu && newItem is MenuData.HeaderMenu) ||
                (oldItem is MenuData.MenuTechnology && newItem is MenuData.MenuTechnology) ||
                ((oldItem is MenuData.SimpleMenu && newItem is MenuData.SimpleMenu))

    override fun areContentsTheSame(oldItem: MenuData, newItem: MenuData): Boolean {
        return oldItem == newItem
    }
}
