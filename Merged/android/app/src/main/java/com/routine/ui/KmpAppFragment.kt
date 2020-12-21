package com.routine.ui

import android.os.Bundle
import android.view.View
import androidx.activity.OnBackPressedCallback
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.commit
import com.instinctools.routine_kmp.di.AppComponent
import com.instinctools.routine_kmp.di.ComponentsProvider
import com.instinctools.routine_kmp.di.DaggerAppComponent
import com.instinctools.routine_kmp.ui.BaseFragment
import com.instinctools.routine_kmp.ui.RootNavigator
import com.instinctools.routine_kmp.ui.list.NavigationMenuCallback
import com.instinctools.routine_kmp.ui.list.TodoListFragment
import com.routine.R
import com.routine.common.vm.HomeViewModel
import dev.chrisbanes.insetter.Insetter
import dev.chrisbanes.insetter.Side
import timber.log.Timber

class KmpAppFragment : BaseFragment(R.layout.fragment_kmp_app), RootNavigator, ComponentsProvider, NavigationMenuCallback {

    private val homeViewModel by activityViewModels<HomeViewModel>()
    override lateinit var appComponent: AppComponent

    private val backPressCallback = object : OnBackPressedCallback(false) {
        override fun handleOnBackPressed() {
            goBack()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        appComponent = DaggerAppComponent.factory().create(requireContext().applicationContext)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        Insetter.builder()
            .applySystemWindowInsetsToMargin(Side.TOP)
            .applyToView(view)

        if (savedInstanceState == null) {
            goto(TodoListFragment.newInstance(navigationEnabled = true), addToBackStack = false)
        }

        childFragmentManager.addOnBackStackChangedListener {
            val childrenCount = childFragmentManager.backStackEntryCount
            backPressCallback.isEnabled = childrenCount > 0
        }
        requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner, backPressCallback)
    }

    override fun goBack() {
        childFragmentManager.popBackStackImmediate()
    }

    override fun goto(fragment: Fragment, addToBackStack: Boolean) {
        childFragmentManager.commit {
            replace(R.id.kmp_fragment_container, fragment)
            if (addToBackStack) addToBackStack(null)
        }
    }

    override fun onNavigationClicked() {
        homeViewModel.onMenuClicked()
    }
}