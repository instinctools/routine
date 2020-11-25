package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.domain.task.GetTaskByIdSideEffect
import com.instinctools.routine_kmp.domain.task.SaveTaskSideEffect
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter.*
import com.instinctools.routine_kmp.ui.todo.details.model.*
import com.instinctools.routine_kmp.util.OneTimeEvent
import kotlinx.coroutines.launch

class TodoDetailsPresenter(
    private val todoId: String?,
    getTaskByIdSideEffect: GetTaskByIdSideEffect,
    saveTaskSideEffect: SaveTaskSideEffect
) : Store<Action, State>(State()) {

    init {
        if (todoId != null) {
            scope.launch {
                val todo = todoRepository.getTodoById(todoId) ?: return@launch
                val periods = state.periods.adjustCount(todo.periodUnit, todo.periodValue)
                sendState(state.copy(todo = todo.edit(), periods = periods))
            }
        }
    }

    override suspend fun reduce(oldState: State, action: Action): State = when (action) {
        is Action.ChangeTitle -> {
            val todo = oldState.todo.copy(title = action.title)
            if (todo != oldState.todo) sendState(oldState.copy(todo = todo))
        }
        is Action.ChangePeriodUnit -> {
            val todo = oldState.todo
            val count = if (todo.periodUnit != action.periodUnit) 1 else todo.periodValue
            val newTodo = todo.copy(periodUnit = action.periodUnit, periodValue = count)
            sendState(oldState.copy(todo = newTodo))
        }
        is Action.ChangePeriod -> {
            val todo = oldState.todo.copy(periodValue = action.period)
            val selectedUnit = todo.periodUnit ?: PeriodUnit.DAY
            val newPeriods = oldState.periods.adjustCount(selectedUnit, action.period)
            sendState(oldState.copy(todo = todo, periods = newPeriods))
        }
        is Action.ChangePeriodStrategy -> {
            val todo = oldState.todo.copy(periodStrategy = action.periodStrategy)
            sendState(oldState.copy(todo = todo))
        }
        Action.Save -> trySave()
    }


    private fun validState(newState: State): State {
        val errors = mutableSetOf<ValidationError>()
        val todo = newState.todo
        if (todo.title.isNullOrEmpty()) {
            errors += ValidationError.EmptyTitle
        }
        if (todo.periodUnit == null) {
            errors += ValidationError.PeriodNotSelected
        }
        val saveEnabled = errors.isEmpty()
        return newState.copy(saveEnabled = saveEnabled, validationErrors = errors)
    }

    private fun sendState(newState: State) {
        val state = validState(newState)
        _states.offer(state)
    }

    data class State(
        val todo: EditableTodoUiModel = EditableTodoUiModel(),
        val periods: List<PeriodUnitUiModel> = allPeriodUiModels(),
        val saved: Boolean = false,
        val saveEnabled: Boolean = false,
        val validationErrors: Set<ValidationError> = emptySet(),
        val saveError: OneTimeEvent<Throwable>? = null
    )

    sealed class Action {
        object Save : Action()
        class ChangeTitle(val title: String?) : Action()
        class ChangePeriodUnit(val periodUnit: PeriodUnit) : Action()
        class ChangePeriod(val period: Int) : Action()
        class ChangePeriodStrategy(val periodStrategy: PeriodResetStrategy) : Action()
    }
}