package com.instinctools.routine_kmp.ui.todo.details

import com.instinctools.routine_kmp.data.TodoStore
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.ui.Presenter
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ConflatedBroadcastChannel
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.launch

class TodoDetailsPresenter(
    private val todoId: Long?,
    private val todoStore: TodoStore
) : Presenter<TodoDetailsPresenter.State, TodoDetailsPresenter.Event>() {

    private val _states = ConflatedBroadcastChannel<State>()
    override val states: Flow<State> get() = _states.asFlow()

    private val _events = Channel<Event>(Channel.RENDEZVOUS)
    override val events: SendChannel<Event> get() = _events

    private val state: State get() = _states.valueOrNull ?: State()

    init {
        val periods = PeriodUnit.values().map { PeriodUiModel(it) }
        sendState(state.copy(periods = periods))
    }

    override fun start() {
        if (todoId != null) {
            scope.launch {
                val todo = todoStore.getTodoById(todoId) ?: return@launch
                sendState(state.copy(todo = todo.toEditModel()))
            }
        }

        scope.launch {
            for (event in _events) {
                when (event) {
                    is Event.ChangeTitle -> {
                        val todo = state.todo.copy(title = event.title)
                        if (todo != state.todo) sendState(state.copy(todo = todo))
                    }
                    is Event.ChangePeriodUnit -> {
                        val todo = state.todo.copy(periodUnit = event.periodUnit)
                        sendState(state.copy(todo = todo))
                    }
                    is Event.ChangePeriod -> {
                        val todo = state.todo.copy(periodValue = event.period)
                        sendState(state.copy(todo = todo))
                    }
                    Event.Save -> save()
                }
            }
        }
    }

    private suspend fun save() {
        val todo = state.todo
        if (todoId == null) {
            val newTodo = todo.buildNewTodoModel()
            if (newTodo == null) {
                // TODO send error state
            } else {
                todoStore.insert(newTodo)
            }
        } else {
            val updatedTodo = todo.buildUpdatedTodoModel()
            if (updatedTodo == null) {
                // TODO send error state
            } else {
                todoStore.update(updatedTodo)
            }
        }
        sendState(state.copy(saved = true))
    }

    private fun sendState(newState: State) {
        _states.offer(newState)
    }

    data class State(
        val todo: EditTodoUiModel = EditTodoUiModel(),
        val saved: Boolean = false,
        val periods: List<PeriodUiModel> = emptyList()
    )

    sealed class Event {
        object Save : Event()
        class ChangeTitle(val title: String?) : Event()
        class ChangePeriodUnit(val periodUnit: PeriodUnit) : Event()
        class ChangePeriod(val period: Int) : Event()
    }
}