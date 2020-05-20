package com.routine.android.vm

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import kotlinx.coroutines.ExperimentalCoroutinesApi

@ExperimentalCoroutinesApi
class DetailsViewModelFactory(val id: String?) : ViewModelProvider.NewInstanceFactory() {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel?> create(modelClass: Class<T>): T =
        when {
            modelClass.isAssignableFrom(DetailsViewModel::class.java) -> DetailsViewModel(id)
            else -> throw UnsupportedOperationException("Cant handle such ViewModel class: $modelClass")
        } as T
}