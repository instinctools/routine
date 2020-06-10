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
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ConflatedBroadcastChannel
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.math.max

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
            todoRepository.refresh()
        }

        todoRepository.getTodosSortedByDate()
            .flowOn(Dispatchers.Default)
            .onEach { updateUiTodos(it) }
            .launchIn(scope)

        scope.launch {
            for (event in _events) {
                when (event) {
                    is Event.Reset -> {
                        val todo = requireNotNull(todoRepository.getTodoById(event.id)) { "Failed to load todo with id=${event.id}" }
                        val resetter = TodoResetterFactory.get(todo.periodStrategy)
                        val resetTodo = resetter.reset(todo)
                        todoRepository.update(resetTodo)
                    }
                    is Event.Delete -> withContext(NonCancellable) {
                        todoRepository.delete(event.id)
                    }
                }
            }
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
    }

    data class State(
        val expiredTodos: List<TodoListUiModel> = emptyList(),
        val futureTodos: List<TodoListUiModel> = emptyList()
    )
}