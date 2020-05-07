package com.instinctools.routine_android

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.instinctools.routine_android.databinding.ActivityDetailsBinding
import kotlinx.android.synthetic.main.activity_details.view.*

class DetailsActivity : AppCompatActivity() {

    private val binding: ActivityDetailsBinding by viewBinding(ActivityDetailsBinding::inflate)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        binding.toolbar.setNavigationOnClickListener {
            onBackPressed()
        }

        binding.toolbar.menu.findItem(R.id.done)
            .actionView.setOnClickListener {

            }


        binding.radio.setOnCheckedChangeListener { _, checkedId ->
            if (checkedId == R.id.every_day){
                WheelPickerFragment().show(supportFragmentManager, WheelPickerFragment::class.java.simpleName)
            }
        }
    }
}
