package com.instinctools.routine_kmp.ui.details.adapter

import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ItemPeriodBinding
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.util.title

class PeriodViewHolder(
    private val binding: ItemPeriodBinding
) : RecyclerView.ViewHolder(binding.root) {

    private lateinit var unit: PeriodUnit
    private val colorIconSelected = ContextCompat.getColor(itemView.context, R.color.selected_text)
    private val colorIconNormal = ContextCompat.getColor(itemView.context, R.color.unselected_text)

    fun bind(periodUnit: PeriodUnit) {
        this.unit = periodUnit
        binding.periodTitle.text = periodUnit.name
    }

    fun setSelected(selectedPeriodUnit: PeriodUnit?, selectedCount: Int) {
        if (selectedPeriodUnit == unit) {
            itemView.isSelected = true
            binding.periodTitle.text = unit.title(selectedCount)
            setIconColor(colorIconSelected)
        } else {
            itemView.isSelected = false
            binding.periodTitle.text = unit.title()
            setIconColor(colorIconNormal)
        }
    }

    private fun setIconColor(color: Int) {
        binding.countSelectionView.setColorFilter(color)
    }
}