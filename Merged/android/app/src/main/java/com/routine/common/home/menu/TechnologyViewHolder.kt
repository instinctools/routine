package com.routine.common.home.menu

import androidx.recyclerview.widget.RecyclerView
import com.routine.databinding.ItemMenuTechnologyBinding

class TechnologyViewHolder(binding: ItemMenuTechnologyBinding, menuClicks: MenuClicks) :
    RecyclerView.ViewHolder(binding.root), MenuClicks by menuClicks
