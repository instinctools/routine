package com.instinctools.routine_android

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.setFragmentResult
import com.instinctools.routine_android.databinding.FragmentWheelPickerBinding

class WheelPickerFragment : DialogFragment() {

    private val binding: FragmentWheelPickerBinding by viewBinding(FragmentWheelPickerBinding::bind)

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_wheel_picker, null, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val period = arguments?.getInt(ARG_PERIOD)

        binding.close.setOnClickListener {
            dismiss()
        }


        binding.wheelPicker.data = IntRange(0, 100).toList()
        period?.let {
            binding.wheelPicker.post {
                binding.wheelPicker.setSelectedItemPosition(period, false)
            }
        }
        binding.wheelPicker.setOnItemSelectedListener { _, data, _ ->
            if(isAdded) {
                setFragmentResult(ARG_PERIOD, Bundle().apply {
                    putInt(ARG_PERIOD, data as Int)
                })
            }
        }
    }

    override fun onResume() {
        super.onResume()
        dialog?.window?.let {
            it.setWindowAnimations(R.style.SlideAnimation)
            it.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            it.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        }
    }
}