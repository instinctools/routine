package com.routine.common.home

import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.routine.databinding.ItemMenuTechnologyBinding

class TechnologyViewHolder(private val binding: ItemMenuTechnologyBinding) :
    RecyclerView.ViewHolder(binding.root) {

    init {
        binding.root.setOnClickListener {
            if (binding.technologyGroup.visibility == View.VISIBLE){
                binding.technologyGroup.visibility = View.GONE
            } else {
                binding.technologyGroup.visibility = View.VISIBLE
            }
        }
    }
}
