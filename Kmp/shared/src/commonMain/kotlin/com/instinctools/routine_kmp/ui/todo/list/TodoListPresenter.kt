package com.instinctools.routine_kmp.ui.todo.list

import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.domain.task.DeleteTaskSideEffect
import com.instinctools.routine_kmp.domain.task.GetTasksSideEffect
import com.instinctools.routine_kmp.domain.task.RefreshTasksSideEffect
import com.instinctools.routine_kmp.domain.task.ResetTaskSideEffect
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter.Action
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter.State
import com.instinctools.routine_kmp.util.ConsumableEvent

class TodoListPresenter(
    getTasksSideEffect: GetTasksSideEffect,
    deleteTaskSideEffect: DeleteTaskSideEffect,
    resetTaskSideEffect: ResetTaskSideEffect,
    refreshTasksSideEffect: RefreshTasksSideEffect,
) : Store<Action, State>(State()) {

    init {
        registerSideEffect(
            sideEffect = refreshTasksSideEffect,
            inputCreator = { if (it == Action.Refresh) Unit else null },
            outputConverter = { Action.RefreshStatusChanged(it) }
        )
        registerSideEffect(
            sideEffect = resetTaskSideEffect,
            inputCreator = { if (it is Action.ResetTask) ResetTaskSideEffect.Input(it.taskId) else null },
            outputConverter = { Action.ResetTaskStatusChanged(it) }
        )
        registerSideEffect(
            sideEffect = deleteTaskSideEffect,
            inputCreator = { if (it is Action.DeleteTask) DeleteTaskSideEffect.Input(it.taskId) else null },
            outputConverter = { Action.DeleteTaskStatusChanged(it) }
        )
        registerSideEffect(
            sideEffect = getTasksSideEffect,
            inputCreator = { if (it == Action.GetTasks) Unit else null },
            outputConverter = { Action.TasksLoaded(it) }
        )
    }

    override suspend fun reduce(oldState: State, action: Action): State = when (action) {
        Action.GetTasks -> oldState
        is Action.TasksLoaded -> oldState.withTasksOutput(action.status)
        is Action.ResetTask -> oldState.

        is Action.ResetTask, is Action.DeleteTask, is Action.Refresh -> oldState
    }

    sealed class Action {
        object GetTasks : Action()
        class TasksLoaded(val status: EffectStatus<GetTasksSideEffect.Output>) : Action()

        class ResetTask(val taskId: String) : Action()
        class ResetTaskStatusChanged(val status: EffectStatus<Boolean>) : Action()

        class DeleteTask(val taskId: String) : Action()
        class DeleteTaskStatusChanged(val status: EffectStatus<Boolean>) : Action()

        object Refresh : Action()
        class RefreshStatusChanged(val status: EffectStatus<Boolean>) : Action()
    }

    data class State(
        val expiredTodos: List<TodoListUiModel> = emptyList(),
        val futureTodos: List<TodoListUiModel> = emptyList(),
        val progress: Boolean = false,

        val refreshError: ConsumableEvent<Throwable>? = null,
        val deleteError: ConsumableEvent<Throwable>? = null,
        val resetError: ConsumableEvent<Throwable>? = null
    ) {
        fun withTasksOutput(status: EffectStatus<GetTasksSideEffect.Output>): State {
            return if (status.data != null) copy(
                expiredTodos = status.data.expiredTodos,
                futureTodos = status.data.futureTodos
            ) else this
        }
    }
}