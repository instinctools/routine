package com.routine.android.vm

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.asFlow
import androidx.lifecycle.asLiveData
import com.routine.android.data.db.database
import com.routine.android.data.db.entity.PeriodUnit
import com.routine.android.data.db.entity.TodoEntity
import com.routine.android.push
import com.routine.android.vm.status.State
import com.routine.android.vm.status.StatusViewMode
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.combine
import java.util.*

@ExperimentalCoroutinesApi
class DetailsViewModel(val id: String?) : StatusViewMode() {

    val todo = MutableLiveData(TodoEntity(UUID.randomUUID().toString(), "", 1, PeriodUnit.DAY, Date()))

    private val textValidation = MutableStateFlow(false)

    val validation = combine(textValidation, getStatus(STATUS_ADD_TODO).state) { text, progress ->
        text && progress.peekContent() != State.PROGRESS
    }

    val addTodoResult = MutableLiveData(false)

    companion object {
        const val STATUS_GET_TODO = "STATUS_GET_TODO"
        const val STATUS_ADD_TODO = "STATUS_ADD_TODO"
    }

    init {
        process(STATUS_GET_TODO) {
            delay(1000)
            if (id != null) {
                todo.push(database().todos().getTodo(id))
            }
        }
    }

    fun saveTodo() {
        process(STATUS_ADD_TODO) {
            todo.value?.let {
                database().todos().addTodo(it)
                addTodoResult.push(true)
            }
        }
    }

    fun onTextChanged(text: String) {
        todo.value = todo.value?.copy(title = text)
        textValidation.value = text.isNotEmpty()
    }

    fun onPeriodChanged(period: Int) {
        todo.value = todo.value?.copy(period = period)
    }

    fun onPeriodUnitChanged(periodUnit: PeriodUnit) {
        todo.value = todo.value?.copy(periodUnit = periodUnit)
    }
}