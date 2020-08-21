package com.routine.common.home.menu

import android.view.View
import com.routine.databinding.ItemMenuTechnologyBinding
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.*
import reactivecircus.flowbinding.android.view.clicks

interface MenuClicks {
    fun menuClicks(): Flow<Menu>
}

class MenuClicksImpl(val view: View) : MenuClicks {

    var menu: Menu? = null

    override fun menuClicks(): Flow<Menu> =
        view.clicks()
            .map { menu }
            .filter { it != null }
            .map { it!! }
}

class MenuTechnologyClicks(val binding: ItemMenuTechnologyBinding) : MenuClicks {

    private var isExpanded = false

    @ExperimentalCoroutinesApi
    override fun menuClicks(): Flow<Menu> =
        merge(
            binding.title.clicks()
                .onEach {
                    if (isExpanded) {
                        binding.root.transitionToStart()
                    } else {
                        binding.root.transitionToEnd()
                    }
                    isExpanded = !isExpanded
                }
                .map { Menu.TECHNOLOGY },
            binding.technologyAndroidNative.clicks()
                .map { Menu.ANDROID_NATIVE },
            binding.technologyReactNative.clicks()
                .map { Menu.REACT_NATIVE },
            binding.technologyFlutter.clicks()
                .map { Menu.FLUTTER },
            binding.technologyKmp.clicks()
                .map { Menu.KMP }
                .filter { it != Menu.TECHNOLOGY }
        )
}
