package com.routine.ui

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import com.routine.R
import com.routine.common.viewBinding
import com.routine.databinding.FragmentAndroidAppBinding
import com.routine.databinding.FragmentSplashBinding
import dev.chrisbanes.insetter.Insetter
import dev.chrisbanes.insetter.Side

class AndroidAppFragment:Fragment(R.layout.fragment_android_app){

    private val binding by viewBinding(FragmentAndroidAppBinding::bind)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        Insetter.builder()
            .applySystemWindowInsetsToMargin(Side.TOP)
            .applyToView(binding.root)
    }
}
