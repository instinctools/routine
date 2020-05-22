package com.instinctools.routine_kmp.ui.todo.list

import com.instinctools.routine_kmp.data.TodoStore
import com.instinctools.routine_kmp.data.date.compareTo
import com.instinctools.routine_kmp.data.date.currentDate
import com.instinctools.routine_kmp.data.date.dateForTimestamp
import com.instinctools.routine_kmp.model.Todo
import com.instinctools.routine_kmp.model.color.ColorEvaluator
import com.instinctools.routine_kmp.model.color.TodoColor
import com.instinctools.routine_kmp.ui.Presenter
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ConflatedBroadcastChannel
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class TodoListPresenter(
    private val todoStore: TodoStore
) : Presenter<TodoListPresenter.State, TodoListPresenter.Event>() {

    private val _states = ConflatedBroadcastChannel<State>()
    override val states: Flow<State> get() = _states.asFlow()

    private val _events = Channel<Event>(Channel.RENDEZVOUS)
    override val events: SendChannel<Event> get() = _events

    private val state: State get() = _states.valueOrNull ?: State()

    override fun start() {
        todoStore.getTodos()
            .flowOn(Dispatchers.Default)
            .onEach { updateUiTodos(it) }
            .launchIn(scope)

        scope.launch {
            for (event in _events) {
                when (event) {
                    is Event.Reset -> withContext(Dispatchers.Default) {
                        val todo = todoStore.getTodoById(event.id) ?: return@withContext
                        // TODO reset task
                        todoStore.update(todo)
                    }
                    is Event.Delete -> withContext(Dispatchers.Default + NonCancellable) {
                        todoStore.delete(event.id)
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
                expiredTodos += TodoListUiModel(todo, TodoColor.EXPIRED_TODO)
            } else {
                val fraction = index / todosCount.toFloat()
                futureTodos += TodoListUiModel(todo, ColorEvaluator.evaluate(fraction, TodoColor.TODOS_START, TodoColor.TODOS_END))
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
        class Reset(val id: Long) : Event()
        class Delete(val id: Long) : Event()
    }

    data class State(
        val expiredTodos: List<TodoListUiModel> = emptyList(),
        val futureTodos: List<TodoListUiModel> = emptyList()
    )
}