package com.routine.common.home

import androidx.recyclerview.widget.RecyclerView
import com.routine.databinding.ItemMenuTechnologyBinding

class TechnologyViewHolder(private val binding: ItemMenuTechnologyBinding) :
    RecyclerView.ViewHolder(binding.root) {

    var isExpanded = false

    init {
        binding.title.setOnClickListener {
            if (isExpanded){
                binding.root.transitionToStart()
            } else {
                binding.root.transitionToEnd()
            }
            isExpanded = !isExpanded
        }
    }
}
