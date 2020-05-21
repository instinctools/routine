package com.instinctools.routine_kmp.ui.todo

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

class TodoListPresenter(
    private val todoStore: TodoStore
) : Presenter<TodoListPresenter.State, TodoListPresenter.Event>() {

    private val _states = ConflatedBroadcastChannel<State>()
    override val states: Flow<State> get() = _states.asFlow()

    private val _events = Channel<Event>(Channel.RENDEZVOUS)
    override val events: SendChannel<Event> get() = _events

    private val state: State get() = _states.valueOrNull ?: State()

    fun start() {
        todoStore.getTodos()
            .flowOn(Dispatchers.Default)
            .onEach { updateUiTodos(it) }
            .launchIn(scope)
    }

    fun resetTodo(id: Long) {
        scope.launch(Dispatchers.Default) {
            val todo = todoStore.getTodoById(id) ?: return@launch
            // TODO reset task
            todoStore.update(todo)
        }
    }

    fun deleteTodo(id: Long) {
        scope.launch(Dispatchers.Default + NonCancellable) {
            todoStore.delete(id)
        }
    }

    private fun updateUiTodos(todos: List<Todo>) {
        val expiredTodos = mutableListOf<TodoUiModel>()
        val futureTodos = mutableListOf<TodoUiModel>()

        val todosCount = todos.count()
        val currentDate = currentDate()
        todos.forEachIndexed { index, todo ->
            val todoDate = dateForTimestamp(todo.nextTimestamp)
            if (todoDate < currentDate) {
                expiredTodos += TodoUiModel(todo, TodoColor.EXPIRED_TODO)
            } else {
                val fraction = index / todosCount.toFloat()
                futureTodos += TodoUiModel(todo, ColorEvaluator.evaluate(fraction, TodoColor.TODOS_START, TodoColor.TODOS_END))
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

    sealed class Event
    data class State(
        val expiredTodos: List<TodoUiModel> = emptyList(),
        val futureTodos: List<TodoUiModel> = emptyList()
    )
}