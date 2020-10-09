package com.routine.vm

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.routine.App
import com.routine.data.repo.TodosRepository
import dagger.hilt.EntryPoint
import dagger.hilt.InstallIn
import dagger.hilt.android.EntryPointAccessors
import dagger.hilt.android.components.ApplicationComponent
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview

@ExperimentalStdlibApi
@ExperimentalCoroutinesApi
class DetailsViewModelFactory(val id: String?) : ViewModelProvider.NewInstanceFactory() {

    @FlowPreview
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel?> create(modelClass: Class<T>): T =
        when {
            modelClass.isAssignableFrom(DetailsViewModel::class.java) ->
                DetailsViewModel(
                    id, EntryPointAccessors.fromApplication(
                        App.CONTEXT,
                        DetailsViewModelFactoryProvider::class.java
                    ).todosRepository()
                )
            else -> throw UnsupportedOperationException("Cant handle such ViewModel class: $modelClass")
        } as T

    @InstallIn(ApplicationComponent::class)
    @EntryPoint
    interface DetailsViewModelFactoryProvider {
        fun todosRepository(): TodosRepository
    }
}
