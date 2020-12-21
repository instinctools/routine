package com.instinctools.routine_kmp.util

import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.instinctools.routine_kmp.di.AppComponent
import com.instinctools.routine_kmp.di.ComponentsProvider
import com.instinctools.routine_kmp.ui.PresenterContainer
import com.instinctools.routine_kmp.ui.RootNavigator

inline fun <reified Presenter> Fragment.presenterContainer(
    crossinline provider: () -> Presenter
) = viewModels<PresenterContainer<Presenter>> {
    object : ViewModelProvider.Factory {
        override fun <T : ViewModel?> create(modelClass: Class<T>) = PresenterContainer(provider()) as T
    }
}

val Fragment.injector: AppComponent
    get() {
        val provider = findFirstResponder<ComponentsProvider>()
        checkNotNull(provider) { "One of parents should extend ComponentsProvider" }
        return provider.appComponent
    }

val Fragment.rootNavigator: RootNavigator
    get() {
        val navigator = findFirstResponder<RootNavigator>()
        return checkNotNull(navigator) { "One of parents should extend RootNavigator" }
    }

inline fun <reified T> Fragment.findFirstResponder(): T? {
    val application = requireContext().applicationContext
    if (application is T) return application

    val activity = requireActivity()
    if (activity is T) return activity

    var parent = parentFragment
    while (parent != null) {
        if (parent is T) return parent
        parent = parent.parentFragment
    }

    return null
}
