package com.instinctools.routine_kmp.util

import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.instinctools.routine_kmp.di.AppComponent
import com.instinctools.routine_kmp.di.ComponentsProvider
import com.instinctools.routine_kmp.ui.PresenterContainer
import com.instinctools.routine_kmp.ui.RootNavigator

val Fragment.injector: AppComponent
    get() {
        val application = requireContext().applicationContext
        require(application is ComponentsProvider) { "Application should extend ComponentsProvider" }
        return application.appComponent
    }

inline fun <reified Presenter> Fragment.presenterContainer(
    crossinline provider: () -> Presenter
) = viewModels<PresenterContainer<Presenter>> {
    object : ViewModelProvider.Factory {
        override fun <T : ViewModel?> create(modelClass: Class<T>) = PresenterContainer(provider()) as T
    }
}

val Fragment.rootNavigator: RootNavigator
    get() {
        val activity = requireActivity()
        require(activity is RootNavigator) { "Parent activity should have RootNavigator" }
        return activity
    }
