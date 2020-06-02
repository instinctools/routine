package com.instinctools.routine_kmp.ui.details.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.databinding.ItemPeriodBinding
import com.instinctools.routine_kmp.model.PeriodUnit

class PeriodsAdapter(
    private val selectionListener: (position: Int, item: PeriodUnit) -> Unit,
    private val countChooserListener: (position: Int, item: PeriodUnit) -> Unit
) : RecyclerView.Adapter<PeriodViewHolder>() {

    private var _items: List<PeriodUnit>? = null
    var items: List<PeriodUnit>
        get() = _items!!
        set(value) {
            _items = value
        }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PeriodViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        val binding = ItemPeriodBinding.inflate(inflater, parent, false)
        return PeriodViewHolder(binding).also { holder ->
            binding.root.setOnClickListener {
                val adapterPosition = holder.adapterPosition
                if (adapterPosition >= 0) {
                    selectionListener(adapterPosition, items[adapterPosition])
                }
            }
            binding.countSelectionView.setOnClickListener {
                val adapterPosition = holder.adapterPosition
                if (adapterPosition >= 0) {
                    countChooserListener(adapterPosition, items[adapterPosition])
                }
            }
        }
    }

    override fun getItemCount() = _items?.size ?: 0

    override fun onBindViewHolder(holder: PeriodViewHolder, position: Int) {
        val item = items[position]
        holder.bind(item)
    }
}