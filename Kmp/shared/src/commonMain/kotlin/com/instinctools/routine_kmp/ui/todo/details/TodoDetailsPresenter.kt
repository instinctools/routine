package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.domain.task.GetTaskByIdSideEffect
import com.instinctools.routine_kmp.domain.task.SaveTaskSideEffect
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.todo.EditableTodo
import com.instinctools.routine_kmp.model.todo.edit
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter.Action
import com.instinctools.routine_kmp.ui.todo.details.TodoDetailsPresenter.State
import com.instinctools.routine_kmp.ui.todo.details.model.PeriodUnitUiModel
import com.instinctools.routine_kmp.ui.todo.details.model.ValidationError
import com.instinctools.routine_kmp.ui.todo.details.model.adjustCount
import com.instinctools.routine_kmp.ui.todo.details.model.allPeriodUiModels
import com.instinctools.routine_kmp.util.OneTimeEvent

class TodoDetailsPresenter(
    todoId: String?,
    getTaskByIdSideEffect: GetTaskByIdSideEffect,
    saveTaskSideEffect: SaveTaskSideEffect
) : Store<Action, State>(State(todoId)) {

    init {
        registerSideEffect(
            sideEffect = getTaskByIdSideEffect,
            inputCreator = { if (it is Action.GetTask) GetTaskByIdSideEffect.Input(it.taskId) else null },
            outputConverter = { Action.TaskLoadingChanged(it) }
        )
        registerSideEffect(
            sideEffect = saveTaskSideEffect,
            inputCreator = { if (it == Action.SaveTask) SaveTaskSideEffect.Input(states.value.todo) else null },
            outputConverter = { Action.SaveStateChanged(it) }
        )

        if (todoId != null) sendAction(Action.GetTask(todoId))
    }

    override suspend fun reduce(oldState: State, action: Action): State = when (action) {
        is Action.GetTask, Action.SaveTask -> oldState
        is Action.TaskLoadingChanged -> oldState.withLoadedTodo(action.status)

        is Action.ChangeTitle -> oldState.withEditTodo { todo.copy(title = action.title) }
        is Action.ChangePeriodStrategy -> oldState.withEditTodo { todo.copy(periodStrategy = action.periodStrategy) }
        is Action.ChangePeriodUnit -> oldState.withEditTodo {
            val count = if (todo.periodUnit != action.periodUnit) 1 else todo.periodValue
            todo.copy(periodUnit = action.periodUnit, periodValue = count)
        }
        is Action.ChangePeriod -> {
            val todo = oldState.todo.copy(periodValue = action.period)
            val selectedUnit = todo.periodUnit ?: PeriodUnit.DAY
            val newPeriods = oldState.periods.adjustCount(selectedUnit, action.period)
            oldState.copy(todo = todo, periods = newPeriods)
        }

        is Action.SaveStateChanged -> oldState.copy(
            saveProgress = action.status.progress,
            saveError = OneTimeEvent(action.status.error),
            saved = OneTimeEvent(action.status.data)
        )
    }

    sealed class Action {
        class ChangeTitle(val title: String?) : Action()
        class ChangePeriodUnit(val periodUnit: PeriodUnit) : Action()
        class ChangePeriod(val period: Int) : Action()
        class ChangePeriodStrategy(val periodStrategy: PeriodResetStrategy) : Action()

        class GetTask(val taskId: String) : Action()
        class TaskLoadingChanged(val status: EffectStatus<GetTaskByIdSideEffect.Output>) : Action()

        object SaveTask : Action()
        class SaveStateChanged(val status: EffectStatus<Boolean>) : Action()
    }

    data class State(
        val todoId: String?,
        val todo: EditableTodo = EditableTodo(),
        val periods: List<PeriodUnitUiModel> = allPeriodUiModels(),

        val loadingProgress: Boolean = false,
        val loadingError: OneTimeEvent<Throwable> = OneTimeEvent(),

        val saveProgress: Boolean = false,
        val saved: OneTimeEvent<Boolean> = OneTimeEvent(),
        val saveError: OneTimeEvent<Throwable> = OneTimeEvent()
    ) {

        val progress = saveProgress || loadingProgress

        val validationErrors = mutableSetOf<ValidationError>()
        val saveEnabled: Boolean

        init {
            if (todo.title.isNullOrEmpty()) {
                validationErrors += ValidationError.EmptyTitle
            }
            if (todo.periodUnit == null) {
                validationErrors += ValidationError.PeriodNotSelected
            }
            saveEnabled = validationErrors.isEmpty()
        }

        fun withEditTodo(editor: State.() -> EditableTodo): State {
            val todo = editor()
            return copy(todo = todo)
        }

        fun withLoadedTodo(status: EffectStatus<GetTaskByIdSideEffect.Output>): State {
            val loadedTask = status.data?.task
            return if (loadedTask == null) copy(
                loadingProgress = status.progress,
                loadingError = OneTimeEvent(status.error)
            )
            else copy(
                todo = loadedTask.edit(),
                periods = periods.adjustCount(loadedTask.periodUnit, loadedTask.periodValue),
                loadingProgress = status.progress,
                loadingError = OneTimeEvent(status.error)
            )
        }
    }
}