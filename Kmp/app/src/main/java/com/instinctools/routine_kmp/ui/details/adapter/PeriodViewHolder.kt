package com.instinctools.routine_kmp.ui.details.adapter

import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.databinding.ItemPeriodBinding
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.util.title

class PeriodViewHolder(
    private val binding: ItemPeriodBinding
) : RecyclerView.ViewHolder(binding.root) {

    private lateinit var unit: PeriodUnit

    fun bind(periodUnit: PeriodUnit) {
        this.unit = periodUnit
        binding.periodTitle.text = periodUnit.name
    }

    fun setSelected(selectedPeriodUnit: PeriodUnit?, selectedCount: Int) {
        if (selectedPeriodUnit == unit) {
            binding.periodTitle.text = unit.title(selectedCount)
        } else {
            binding.periodTitle.text = unit.title()
        }
    }
}