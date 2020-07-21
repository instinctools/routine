package com.instinctools.routine_kmp.ui.details

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.fragment.app.DialogFragment
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.FragmentPeriodPickerKmpBinding
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.util.viewBinding

class PeriodPickerFragment : DialogFragment(R.layout.fragment_period_picker_kmp) {

    private val binding by viewBinding(FragmentPeriodPickerKmpBinding::bind)

    private var _period: Int? = null
    private val period: Int get() = _period ?: arguments?.getInt(ARG_SELECTED_PERIOD) ?: 1

    var pickerListener: ((period: Int) -> Unit)? = null

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.numberPicker.data = PeriodUnit.possiblePeriodValuesZeroPadded
        binding.numberPicker.setOnItemSelectedListener { _, data, _ ->
            val periodIndex = PeriodUnit.possiblePeriodValuesZeroPadded.indexOf(data)
            this._period = PeriodUnit.possiblePeriodValues[periodIndex]
        }

        val selectedIndex = PeriodUnit.possiblePeriodValues.indexOf(period)
        binding.numberPicker.setSelectedItemPosition(selectedIndex, false)

        binding.root.setOnClickListener { dismiss() }
        binding.closeBtn.setOnClickListener {
            pickerListener?.invoke(period)
            dismiss()
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
        val TAG = PeriodPickerFragment::class.simpleName
        private const val ARG_SELECTED_PERIOD = "selected_period"

        fun newInstance(selectedPeriod: Int) = PeriodPickerFragment().apply {
            arguments = bundleOf(ARG_SELECTED_PERIOD to selectedPeriod)
        }
    }
}