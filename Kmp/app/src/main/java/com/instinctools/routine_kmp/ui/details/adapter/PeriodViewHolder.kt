package com.instinctools.routine_kmp.ui.details.adapter

import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.databinding.ItemPeriodBinding
import com.instinctools.routine_kmp.model.PeriodUnit

class PeriodViewHolder(
    private val binding: ItemPeriodBinding
) : RecyclerView.ViewHolder(binding.root) {

    fun bind(periodUnit: PeriodUnit) {
        binding.periodTitle.text = periodUnit.name
    }
}