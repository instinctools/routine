package com.instinctools.routine_kmp.details

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.setFragmentResult
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.FragmentWheelPickerBinding
import com.instinctools.routine_kmp.util.viewBinding

class WheelPickerFragment : DialogFragment() {

    private val binding: FragmentWheelPickerBinding by viewBinding(FragmentWheelPickerBinding::bind)

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_wheel_picker, null, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val period = arguments?.getInt(ARG_PERIOD) ?: 1

        binding.wheelPicker.data = IntRange(1, 100).toList()
        binding.wheelPicker.setOnItemSelectedListener { _, data, _ ->
            if (isAdded) {
                setFragmentResult(ARG_PERIOD, bundleOf(ARG_PERIOD to data))
            }
        }

        binding.close.setOnClickListener { dismiss() }

        view.post {
            binding.wheelPicker.setSelectedItemPosition(period - 1, false)
        }
    }

    override fun onResume() {
        super.onResume()
        val window = dialog?.window ?: return
        window.setWindowAnimations(R.style.SlideAnimation)
        window.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
    }

    companion object {
        val TAG = WheelPickerFragment::class.simpleName

        fun newInstance(period: Int) = WheelPickerFragment().apply {
            arguments = bundleOf(ARG_PERIOD to period)
        }
    }
}