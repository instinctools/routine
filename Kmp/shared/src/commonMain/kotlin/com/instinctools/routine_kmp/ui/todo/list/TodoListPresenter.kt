package com.instinctools.routine_kmp.ui.todo.list

import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.domain.task.DeleteTaskSideEffect
import com.instinctools.routine_kmp.domain.task.GetTasksSideEffect
import com.instinctools.routine_kmp.domain.task.RefreshTasksSideEffect
import com.instinctools.routine_kmp.domain.task.ResetTaskSideEffect
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter.Action
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter.State
import com.instinctools.routine_kmp.util.OneTimeEvent
import kotlinx.coroutines.launch

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

        // TODO workaround for not working Dispatcher.Main.immediate in Kotlin/Native: https://github.com/Kotlin/kotlinx.coroutines/issues/2283
        scope.launch {
            sendAction(Action.Refresh)
            sendAction(Action.GetTasks)
        }
    }

    override suspend fun reduce(oldState: State, action: Action): State = when (action) {
        is Action.TasksLoaded -> oldState.withTasksOutput(action.status)
        is Action.ResetTaskStatusChanged -> oldState.withResetState(action.status)
        is Action.DeleteTaskStatusChanged -> oldState.withDeleteState(action.status)
        is Action.RefreshStatusChanged -> oldState.withRefreshState(action.status)

        Action.GetTasks, is Action.ResetTask, is Action.DeleteTask, is Action.Refresh -> oldState
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

        val refreshProgress: Boolean = false,
        val resetProgress: Boolean = false,
        val deleteProgress: Boolean = false,

        val deleteDone: OneTimeEvent<Boolean> = OneTimeEvent(),
        val resetDone: OneTimeEvent<Boolean> = OneTimeEvent(),

        val refreshError: OneTimeEvent<Throwable> = OneTimeEvent(),
        val deleteError: OneTimeEvent<Throwable> = OneTimeEvent(),
        val resetError: OneTimeEvent<Throwable> = OneTimeEvent()
    ) {

        val progress: Boolean = refreshProgress || resetProgress || deleteProgress

        fun withTasksOutput(status: EffectStatus<GetTasksSideEffect.Output>) = if (status.data != null) copy(
            expiredTodos = status.data.expiredTodos,
            futureTodos = status.data.futureTodos
        ) else this

        fun withResetState(status: EffectStatus<Boolean>): State = copy(
            resetProgress = status.progress,
            resetError = OneTimeEvent(status.error),
            resetDone = OneTimeEvent(status.done)
        )

        fun withDeleteState(status: EffectStatus<Boolean>): State = copy(
            deleteProgress = status.progress,
            deleteError = OneTimeEvent(status.error),
            deleteDone = OneTimeEvent(status.done)
        )

        fun withRefreshState(status: EffectStatus<Boolean>): State = copy(
            refreshProgress = status.progress,
            refreshError = OneTimeEvent(status.error),
        )
    }
}