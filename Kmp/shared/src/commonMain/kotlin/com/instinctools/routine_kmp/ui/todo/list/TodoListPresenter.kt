package com.instinctools.routine_kmp.ui.todo.list

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.data.date.compareTo
import com.instinctools.routine_kmp.data.date.currentDate
import com.instinctools.routine_kmp.data.date.dateForTimestamp
import com.instinctools.routine_kmp.data.date.daysBetween
import com.instinctools.routine_kmp.model.Todo
import com.instinctools.routine_kmp.model.color.ColorEvaluator
import com.instinctools.routine_kmp.model.color.TodoColor
import com.instinctools.routine_kmp.model.reset.TodoResetterFactory
import com.instinctools.routine_kmp.ui.Presenter
import com.instinctools.routine_kmp.util.ConsumableEvent
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ConflatedBroadcastChannel
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.flow.*

class TodoListPresenter(
    private val todoRepository: TodoRepository
) : Presenter<TodoListPresenter.State, TodoListPresenter.Event>() {

    private val _states = ConflatedBroadcastChannel<State>()
    override val states: Flow<State> get() = _states.asFlow()

    private val _events = Channel<Event>(Channel.RENDEZVOUS)
    override val events: SendChannel<Event> get() = _events

    private val state: State get() = _states.valueOrNull ?: State()

    override fun start() {
        scope.launch {
            tryRefresh()
        }

        todoRepository.getTodosSortedByDate()
            .flowOn(Dispatchers.Default)
            .onEach { updateUiTodos(it) }
            .launchIn(scope)

        scope.launch {
            for (event in _events) {
                when (event) {
                    is Event.Reset -> tryReset(event.id)
                    is Event.Delete -> tryDelete(event.id)
                    Event.Refresh -> tryRefresh()
                }
            }
        }
    }

    private suspend fun tryRefresh() {
        try {
            sendState(state.copy(refreshing = true, refreshError = null))
            todoRepository.refresh()
            sendState(state.copy(refreshing = false))
        } catch (error: Throwable) {
            if (error is CancellationException) return
            sendState(state.copy(refreshing = false, refreshError = ConsumableEvent(error)))
        }
    }

    private suspend fun tryDelete(todoId: String) = withContext(NonCancellable) {
        try {
            sendState(state.copy(refreshing = true, deleteError = null))
            todoRepository.delete(todoId)
            sendState(state.copy(refreshing = false))
        } catch (error: Throwable) {
            if (error is CancellationException) return@withContext
            sendState(state.copy(refreshing = false, deleteError = ConsumableEvent(error)))
        }
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

    private fun sendState(newState: State) {
        _states.offer(newState)
    }

    sealed class Event {
        class Reset(val id: String) : Event()
        class Delete(val id: String) : Event()
        object Refresh : Event()
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