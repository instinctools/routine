package com.routine.vm

import androidx.lifecycle.ViewModel
import com.dropbox.android.external.store4.ResponseOrigin
import com.dropbox.android.external.store4.StoreRequest
import com.dropbox.android.external.store4.StoreResponse
import com.routine.common.calculateTimestamp
import com.routine.data.db.entity.PeriodUnit
import com.routine.data.db.entity.ResetType
import com.routine.data.db.entity.TodoEntity
import com.routine.data.model.Event
import com.routine.data.repo.TodosRepository
import com.routine.vm.status.cache
import com.routine.vm.status.paramCache
import com.routine.vm.status.runAction
import kotlinx.coroutines.flow.*
import java.util.*

class  DetailsViewModel(private val id: String?, private val todosRepository: TodosRepository) : ViewModel() {

    companion object {
        const val GET_TODO = "GET_TODO"
        const val ADD_TODO = "ADD_TODO"
    }

    val titleFlow = MutableStateFlow("")
    val resetTypeFlow = MutableStateFlow(ResetType.BY_PERIOD)
    val periodSelectionFlow = MutableStateFlow(
        listOf(
            PeriodSelectorData(PeriodUnit.DAY, 1, true),
            PeriodSelectorData(PeriodUnit.MONTH, 1, false),
            PeriodSelectorData(PeriodUnit.WEEK, 1, false)
        )
    )

    val wheelPickerFlow = MutableStateFlow<Event<PeriodSelectorData>?>(null)

    val todo by paramCache(GET_TODO, id ?: "") {
        todosRepository.getTodoStore
            .stream(StoreRequest.cached(it, false))
            .onEach {
                if (it is StoreResponse.Data) {
                    titleFlow.value = it.value.title
                    resetTypeFlow.value = it.value.resetType
                    periodSelectionFlow.value =
                        periodSelectionFlow.value.map { periodSelector ->
                            PeriodSelectorData(
                                periodSelector.periodUnit,
                                if (periodSelector.periodUnit == it.value.periodUnit) it.value.period else periodSelector.period,
                                periodSelector.periodUnit == it.value.periodUnit
                            )
                        }
                }
            }
    }

    val addTodo by cache (ADD_TODO, false) {
        combine(
            titleFlow,
            resetTypeFlow,
            periodSelectionFlow
        ) { title, resetType, periodSelection ->
            Triple(title, resetType, periodSelection.find { it.isSelected })
        }.take(1)
            .flatMapConcat {
                val period = it.third?.period ?: 1
                val periodUnit = it.third?.periodUnit ?: PeriodUnit.DAY

                todosRepository.addTodoStore.stream(
                    StoreRequest.fresh(
                        TodoEntity(
                            id ?: UUID.randomUUID().toString(),
                            it.first,
                            period,
                            periodUnit,
                            calculateTimestamp(period, periodUnit, it.second, null),
                            it.second
                        )
                    )
                )
            }
    }

    val isSaveButtonEnabledFlow = combine(titleFlow, todo,
        addTodo.onStart { emit(StoreResponse.Data(false, ResponseOrigin.Fetcher)) }) { text, todo, addTodo ->
        text.isNotEmpty() && todo !is StoreResponse.Loading && addTodo !is StoreResponse.Loading
    }

    val progressFlow = combine(todo,
        addTodo.onStart { emit(StoreResponse.Data(false, ResponseOrigin.Fetcher)) }) { todo, addTodo ->
        todo is StoreResponse.Loading || addTodo is StoreResponse.Loading
    }

    val errorFlow by cache {
        merge(todo, addTodo)
            .filter { it is StoreResponse.Error.Exception }
            .map {
                Event(it as StoreResponse.Error.Exception)
            }
    }

    fun saveTodo() {
        runAction(Any(), ADD_TODO )
    }

    fun onTextChanged(text: String) {
        titleFlow.value = text
    }

    fun onPeriodChanged(period: Int, periodUnit: PeriodUnit) {
        periodSelectionFlow.value = periodSelectionFlow.value.map {
            if (periodUnit == it.periodUnit) {
                PeriodSelectorData(
                    it.periodUnit,
                    period,
                    it.isSelected
                )
            } else {
                it
            }
        }
    }

    fun onPeriodUnitChanged(periodUnit: PeriodUnit) {
        periodSelectionFlow.value = periodSelectionFlow.value.map {
            PeriodSelectorData(
                it.periodUnit,
                it.period,
                it.periodUnit == periodUnit
            )
        }
    }

    fun onResetTypeChanged(resetType: ResetType) {
        resetTypeFlow.value = resetType
    }

    fun onMenuClicked(periodUnit: PeriodUnit){
        val value = periodSelectionFlow.value.find { it.periodUnit == periodUnit }
        if (value != null){
            wheelPickerFlow.value = Event(value)
        }
    }

    data class PeriodSelectorData(
        val periodUnit: PeriodUnit,
        val period: Int,
        val isSelected: Boolean
    )
}
