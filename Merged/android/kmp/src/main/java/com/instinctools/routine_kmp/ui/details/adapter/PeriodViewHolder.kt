package com.instinctools.routine_kmp.ui.details.adapter

import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ItemPeriodKmpBinding
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.ui.todo.details.model.PeriodUnitUiModel
import com.instinctools.routine_kmp.util.title

class PeriodViewHolder(
    private val binding: ItemPeriodKmpBinding
) : RecyclerView.ViewHolder(binding.root) {

    private lateinit var item: PeriodUnitUiModel
    private val colorIconSelected = ContextCompat.getColor(itemView.context, R.color.selected_text)
    private val colorIconNormal = ContextCompat.getColor(itemView.context, R.color.unselected_text)

    fun bind(item: PeriodUnitUiModel) {
        this.item = item
        binding.periodTitle.text = item.unit.name
        binding.periodTitle.text = item.unit.title(item.count)
    }

    fun setSelected(selectedPeriodUnit: PeriodUnit?) {
        if (selectedPeriodUnit == item.unit) {
            itemView.isSelected = true
            setIconColor(colorIconSelected)
        } else {
            itemView.isSelected = false
            setIconColor(colorIconNormal)
        }
    }

    private fun setIconColor(color: Int) {
        binding.countSelectionView.setColorFilter(color)
    }
}