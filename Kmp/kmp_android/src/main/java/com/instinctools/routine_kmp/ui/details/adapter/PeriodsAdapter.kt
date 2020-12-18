package com.instinctools.routine_kmp.ui.details.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import com.instinctools.routine_kmp.databinding.ItemPeriodBinding
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.ui.todo.details.model.PeriodUnitUiModel

class PeriodsAdapter(
    private val selectionListener: (position: Int, item: PeriodUnitUiModel) -> Unit,
    private val countChooserListener: (position: Int, item: PeriodUnitUiModel) -> Unit
) : ListAdapter<PeriodUnitUiModel, PeriodViewHolder>(PeriodDiff) {

    private val selectionListeners = mutableListOf<(PeriodUnit?) -> Unit>()
    private var selectedPeriodUnit: PeriodUnit? = null

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PeriodViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val binding = ItemPeriodBinding.inflate(inflater, parent, false)
        return PeriodViewHolder(binding).also { holder ->
            binding.root.setOnClickListener {
                val adapterPosition = holder.adapterPosition
                if (adapterPosition >= 0) {
                    selectionListener(adapterPosition, getItem(adapterPosition))
                }
            }
            binding.countSelectionView.setOnClickListener {
                val adapterPosition = holder.adapterPosition
                if (adapterPosition >= 0) {
                    countChooserListener(adapterPosition, getItem(adapterPosition))
                }
            }
            selectionListeners += { unit: PeriodUnit? ->
                holder.setSelected(unit)
            }
        }
    }

    override fun onBindViewHolder(holder: PeriodViewHolder, position: Int) {
        holder.bind(getItem(position))
        holder.setSelected(selectedPeriodUnit)
    }

    fun setSelected(unit: PeriodUnit?) {
        selectedPeriodUnit = unit
        selectionListeners.forEach { it(unit) }
    }
}

private object PeriodDiff : DiffUtil.ItemCallback<PeriodUnitUiModel>() {
    override fun areItemsTheSame(oldItem: PeriodUnitUiModel, newItem: PeriodUnitUiModel): Boolean {
        return oldItem.unit == newItem.unit
    }

    override fun areContentsTheSame(oldItem: PeriodUnitUiModel, newItem: PeriodUnitUiModel): Boolean {
        return oldItem == newItem
    }
}