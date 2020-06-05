package com.instinctools.routine_kmp.ui.widget

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.LinearLayout
import com.instinctools.routine_kmp.databinding.ViewIosLikeToggleBinding

class IosLikeToggle @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : LinearLayout(context, attrs, defStyleAttr) {

    private val binding = ViewIosLikeToggleBinding.inflate(LayoutInflater.from(context), this)

    var settings: Settings<out Any>? = null
        set(value) {
            binding.leftItemView.text = value?.leftItem.toString()
            binding.rightItemView.text = value?.rightItem.toString()
            field = value
        }

    init {
        orientation = HORIZONTAL

        val leftItemView = binding.leftItemView
        val rightItemView = binding.rightItemView

        binding.leftItemView.setOnClickListener {
            leftItemView.isSelected = true
            rightItemView.isSelected = false
            val settings = settings ?: return@setOnClickListener
            settings.selectionListener(settings.leftItem)
        }
        binding.rightItemView.setOnClickListener {
            leftItemView.isSelected = false
            rightItemView.isSelected = true
            val settings = settings ?: return@setOnClickListener
            settings.selectionListener(settings.rightItem)
        }
    }

    class Settings<out T>(
        val leftItem: T,
        val rightItem: T,
        val selectionListener: (Any) -> Unit
    )
}