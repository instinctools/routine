package com.routine.ui

import android.content.Context
import android.graphics.Typeface
import android.os.Bundle
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.TextView
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentResultListener
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.dropbox.android.external.store4.StoreResponse
import com.google.android.material.snackbar.Snackbar
import com.routine.R
import com.routine.common.applyTextAndVisibility
import com.routine.common.lazyOnViewLifecycle
import com.routine.common.viewBinding
import com.routine.data.db.entity.PeriodUnit
import com.routine.data.db.entity.ResetType
import com.routine.databinding.FragmentDetailsBinding
import com.routine.databinding.ItemPeriodSelectorBinding
import com.routine.vm.DetailsViewModel
import com.routine.vm.DetailsViewModelFactory
import dev.chrisbanes.insetter.Insetter
import dev.chrisbanes.insetter.Side
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.merge
import kotlinx.coroutines.flow.onEach
import reactivecircus.flowbinding.android.view.clicks
import reactivecircus.flowbinding.android.widget.checkedChanges
import reactivecircus.flowbinding.android.widget.textChanges

const val ARG_PERIOD = "ARG_PERIOD"
const val ARG_PERIOD_UNIT = "ARG_PERIOD_UNIT"

@FlowPreview
@ExperimentalStdlibApi
@ExperimentalCoroutinesApi
open class DetailsFragment : Fragment(R.layout.fragment_details) {

    private val args: DetailsFragmentArgs by navArgs()
    private val binding: FragmentDetailsBinding by viewBinding(FragmentDetailsBinding::bind)

    private val viewModel by viewModels<DetailsViewModel> {
        DetailsViewModelFactory(args.EXTRAID)
    }

    private val snackbar: Snackbar by lazyOnViewLifecycle ({
        Snackbar.make(binding.root, "", Snackbar.LENGTH_LONG)
            .apply { anchorView =  binding.messageAnchor}
    }, {
        it.dismiss()
    })

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        Insetter.builder()
            .applySystemGestureInsetsToMargin(Side.BOTTOM)
            .applyToView(binding.messageAnchor)

        viewModel.titleFlow
            .onEach {
                if (binding.text.text.toString() != it) {
                    binding.text.setText(it)
                }
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        viewModel.resetTypeFlow
            .onEach {
                binding.reset.check(
                    when (it) {
                        ResetType.BY_DATE -> R.id.reset_date
                        else -> R.id.reset_period
                    }
                )
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        viewModel.periodSelectionFlow
            .onEach {
                it.forEach { data ->
                    val period: ItemPeriodSelectorBinding
                    when (data.periodUnit) {
                        PeriodUnit.DAY -> {
                            period = binding.dayPeriodSelector
                            period.text.text = resources.getQuantityString(R.plurals.day, data.period, data.period)
                        }
                        PeriodUnit.WEEK -> {
                            period = binding.weekPeriodSelector
                            period.text.text = resources.getQuantityString(R.plurals.week, data.period, data.period)
                        }
                        PeriodUnit.MONTH -> {
                            period = binding.monthPeriodSelector
                            period.text.text = resources.getQuantityString(R.plurals.month, data.period, data.period)
                        }
                    }

                    period.text.isSelected = data.isSelected
                    period.periodMenu.isSelected = data.isSelected
                }
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)


        viewModel.progressFlow
            .onEach {
                binding.progress.visibility = if (it) View.VISIBLE else View.GONE
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        viewModel.errorFlow
            .onEach {
                it.getContentIfNotHandled()?.let {
                    snackbar.applyTextAndVisibility(getString(R.string.error))
                }
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        viewModel.isSaveButtonEnabledFlow
            .onEach {
                binding.toolbar.menu.findItem(R.id.done).actionView.run {
                    isEnabled = it
                    if (this is TextView) {
                        typeface = if (it) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
                    }
                }
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        viewModel.addTodo
            .onEach {
                if (it is StoreResponse.Data && it.value) popBackStack()
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        viewModel.wheelPickerFlow
            .onEach {
                val content = it?.getContentIfNotHandled()
                content?.let {
                    WheelPickerFragment().apply {
                        setStyle(DialogFragment.STYLE_NORMAL, R.style.WheelPickerTheme)
                        arguments = Bundle().apply {
                            putInt(ARG_PERIOD, it.period)
                            putSerializable(ARG_PERIOD_UNIT, it.periodUnit)
                        }
                    }.show(childFragmentManager, WheelPickerFragment::class.java.simpleName)
                }
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        binding.text
            .textChanges()
            .onEach {
                viewModel.onTextChanged(it.toString())
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        merge(
            binding.dayPeriodSelector.text
                .clicks()
                .map { PeriodUnit.DAY },
            binding.weekPeriodSelector.text
                .clicks()
                .map { PeriodUnit.WEEK },
            binding.monthPeriodSelector.text
                .clicks()
                .map { PeriodUnit.MONTH }
        )
            .onEach {
                viewModel.onPeriodUnitChanged(it)
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        binding.reset.checkedChanges()
            .onEach {
                viewModel.onResetTypeChanged(
                    if (it == R.id.reset_period) {
                        ResetType.BY_PERIOD
                    } else {
                        ResetType.BY_DATE
                    }
                )
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        binding.toolbar.setNavigationOnClickListener { popBackStack() }

        binding.toolbar.menu.findItem(R.id.done)
            .actionView.clicks()
            .onEach {
                viewModel.saveTodo()
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        merge(
            binding.dayPeriodSelector.periodMenu
                .clicks()
                .map { PeriodUnit.DAY },
            binding.weekPeriodSelector.periodMenu
                .clicks()
                .map { PeriodUnit.WEEK },
            binding.monthPeriodSelector.periodMenu
                .clicks()
                .map { PeriodUnit.MONTH }
        )
            .onEach {
                viewModel.onMenuClicked(it)
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        childFragmentManager.setFragmentResultListener(
            ARG_PERIOD,
            this@DetailsFragment,
            FragmentResultListener { requestKey, result ->
                viewModel.onPeriodChanged(
                    result.getInt(ARG_PERIOD), result.getSerializable(ARG_PERIOD_UNIT) as PeriodUnit
                )
            })
    }

    private fun popBackStack() {
        activity?.let {
            val inputManager = it.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            val view = it.currentFocus
            if (view != null) {
                inputManager.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)
            }
        }
        findNavController().popBackStack()
    }
}
