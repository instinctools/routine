package com.routine.ui

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.DialogFragment.STYLE_NORMAL
import androidx.fragment.app.setFragmentResult
import com.routine.R
import com.routine.common.viewBinding
import com.routine.databinding.FragmentWheelPickerBinding
import dev.chrisbanes.insetter.Insetter
import dev.chrisbanes.insetter.Side

class WheelPickerFragment : DialogFragment() {

    private val binding: FragmentWheelPickerBinding by viewBinding(FragmentWheelPickerBinding::bind)

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_wheel_picker, null, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.root.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN

        Insetter.builder()
            .applySystemWindowInsetsToPadding(Side.LEFT or Side.RIGHT or Side.BOTTOM)
            .applyToView(binding.wheelPicker)

        val period = arguments?.getInt(ARG_PERIOD, 1)

        binding.close.setOnClickListener {
            dismiss()
        }


        binding.wheelPicker.data = IntRange(1, 100).toList()
        binding.wheelPicker.post {
            binding.wheelPicker.setSelectedItemPosition((period ?: 1) - 1, false)
        }
        binding.wheelPicker.setOnItemSelectedListener { _, data, _ ->
            if (isAdded) {
                setFragmentResult(ARG_PERIOD, Bundle().apply {
                    putInt(ARG_PERIOD, data as Int)
                    putSerializable(ARG_PERIOD_UNIT, arguments?.getSerializable(ARG_PERIOD_UNIT))
                })
            }
        }
    }
}
