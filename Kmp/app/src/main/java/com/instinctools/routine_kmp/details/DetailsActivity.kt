package com.instinctools.routine_kmp.details

import android.graphics.Typeface
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.widget.doOnTextChanged
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.databinding.ActivityDetailsBinding

const val ARG_PERIOD = "ARG_PERIOD"

class DetailsActivity : AppCompatActivity() {

    private var period = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = ActivityDetailsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        if (savedInstanceState != null) {
            period = savedInstanceState.getInt(ARG_PERIOD)
        }
        val id = intent.getStringExtra("EXTRA_ID")


        binding.toolbar.setNavigationOnClickListener {
            onBackPressed()
        }
        binding.everyDay.setOnClickListener {
            val fragment = supportFragmentManager.findFragmentByTag(WheelPickerFragment.TAG)
            if (fragment == null) {
                WheelPickerFragment.newInstance(period)
                    .show(supportFragmentManager, WheelPickerFragment.TAG)
            }
        }
        binding.text.doOnTextChanged { text, _, _, _ ->
            val actionView = binding.toolbar.menu.findItem(R.id.done).actionView
            val isTextNotEmpty = !text.isNullOrEmpty()
            actionView.isEnabled = isTextNotEmpty
            if (actionView is TextView) {
                actionView.typeface = if (isTextNotEmpty) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
            }
        }

        binding.radio.setOnCheckedChangeListener { group, checkedId ->
            if (checkedId != R.id.every_day) {
                period = 1
            }
        }
        binding.toolbar.menu.findItem(R.id.done).actionView.setOnClickListener {

        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt(ARG_PERIOD, period)
    }
}