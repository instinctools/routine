package com.instinctools.routine_kmp.ui.widget

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.LinearLayout
import com.instinctools.routine_kmp.databinding.ViewIosLikeToggleKmpBinding

class IosLikeToggle @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : LinearLayout(context, attrs, defStyleAttr) {

    private val binding = ViewIosLikeToggleKmpBinding.inflate(LayoutInflater.from(context), this)

    var settings: Settings<out Any>? = null
        set(value) {
            binding.leftItemView.text = value?.leftItem?.title
            binding.rightItemView.text = value?.rightItem?.title
            field = value
        }

    init {
        orientation = HORIZONTAL

        binding.leftItemView.setOnClickListener {
            if (isSelected) return@setOnClickListener
            val settings = settings ?: return@setOnClickListener
            settings.selectionListener(settings.leftItem.data)
        }
        binding.rightItemView.setOnClickListener {
            if (isSelected) return@setOnClickListener
            val settings = settings ?: return@setOnClickListener
            settings.selectionListener(settings.rightItem.data)
        }
    }

    fun <T> setSelected(data: T) {
        val settings = settings ?: return
        if (settings.leftItem.data == data) {
            binding.leftItemView.isSelected = true
            binding.rightItemView.isSelected = false
        } else if (settings.rightItem.data == data) {
            binding.leftItemView.isSelected = false
            binding.rightItemView.isSelected = true
        }
    }

    class Settings<T>(
        val leftItem: Item<T>,
        val rightItem: Item<T>,
        val selectionListener: (Any) -> Unit
    )

    data class Item<T>(
        val data: T,
        val title: String
    )
}