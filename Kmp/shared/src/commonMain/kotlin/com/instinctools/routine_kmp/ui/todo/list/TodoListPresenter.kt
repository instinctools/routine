package com.instinctools.routine_kmp.ui.todo.list

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.data.date.compareTo
import com.instinctools.routine_kmp.data.date.currentDate
import com.instinctools.routine_kmp.data.date.dateForTimestamp
import com.instinctools.routine_kmp.data.date.daysBetween
import com.instinctools.routine_kmp.domain.SideEffectTrigger
import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.domain.task.DeleteTaskSideEffect
import com.instinctools.routine_kmp.model.Todo
import com.instinctools.routine_kmp.model.color.ColorEvaluator
import com.instinctools.routine_kmp.model.color.TodoColor
import com.instinctools.routine_kmp.model.reset.TodoResetterFactory
import com.instinctools.routine_kmp.ui.todo.list.TodoListPresenter.*
import com.instinctools.routine_kmp.util.ConsumableEvent
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

class TodoListPresenter(
    private val todoRepository: TodoRepository,

    private val deleteTaskSideEffect: DeleteTaskSideEffect,
) : Store<Action, State>(
    initialState = State(),
    sideEffectsTriggers = arrayOf(
        SideEffectTrigger(
            sideEffect = deleteTaskSideEffect,
            triggerActions = arrayOf(null),
            inputCreator = { action, state -> null },
            outputCreator = { effectStatus -> null }
        )
    )
) {

    init {
        scope.launch {
            tryRefresh()
        }

        todoRepository.getTodosSortedByDate()
            .flowOn(Dispatchers.Default)
            .onEach { updateUiTodos(it) }
            .launchIn(scope)
    }

    override suspend fun reduce(oldState: State, action: Action): State = when (action) {
        is Action.ResetTask -> tryReset(action.taskId)
        is Action.DeleteTask -> tryDelete(action.taskId)
        Action.Refresh -> tryRefresh()
    }

    private suspend fun tryReset(todoId: String) {
        try {
            sendState(state.copy(refreshing = true, resetError = null))
            val todo = requireNotNull(todoRepository.getTodoById(todoId)) { "Failed to load todo with id=${todoId}" }
            val resetter = TodoResetterFactory.get(todo.periodStrategy)
            val resetTodo = resetter.reset(todo)

            todoRepository.update(resetTodo)
            sendState(state.copy(refreshing = false))
        } catch (error: Throwable) {
            if (error is CancellationException) return
            sendState(state.copy(refreshing = false, resetError = ConsumableEvent(error)))
        }
    }

    private fun updateUiTodos(todos: List<Todo>) {
        val expiredTodos = mutableListOf<TodoListUiModel>()
        val futureTodos = mutableListOf<TodoListUiModel>()

        val todosCount = todos.count()
        val currentDate = currentDate()
        todos.forEachIndexed { index, todo ->
            val todoDate = dateForTimestamp(todo.nextTimestamp)
            if (todoDate < currentDate) {
                val daysLeft = daysBetween(todoDate, currentDate)
                expiredTodos += TodoListUiModel(todo, TodoColor.EXPIRED_TODO, daysLeft)
            } else {
                val daysLeft = daysBetween(currentDate, todoDate)
                val fraction = index / todosCount.toFloat()
                val color = ColorEvaluator.evaluate(fraction, TodoColor.TODOS_START, TodoColor.TODOS_END)
                futureTodos += TodoListUiModel(todo, color, daysLeft)
            }
        }

        val newState = state.copy(
            expiredTodos = expiredTodos,
            futureTodos = futureTodos
        )
        sendState(newState)
    }

    sealed class Action {
        class ResetTask(val taskId: String) : Action()
        class DeleteTask(val taskId: String) : Action()
        object Refresh : Action()
    }

    data class State(
        val expiredTodos: List<TodoListUiModel> = emptyList(),
        val futureTodos: List<TodoListUiModel> = emptyList(),
        val refreshing: Boolean = false,

        val refreshError: ConsumableEvent<Throwable>? = null,
        val deleteError: ConsumableEvent<Throwable>? = null,
        val resetError: ConsumableEvent<Throwable>? = null
    )
}