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

    private val _states = ConflatedBroadcastChannel(State())
    override val states: Flow<State> get() = _states.asFlow()

    private val _events = Channel<Event>(Channel.RENDEZVOUS)
    override val events: SendChannel<Event> get() = _events

    private val state: State get() = _states.valueOrNull ?: State()

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
                        val todo = state.todo
                        val count = if (todo.periodUnit != event.periodUnit) 1 else todo.periodValue
                        val newTodo = todo.copy(periodUnit = event.periodUnit, periodValue = count)
                        sendState(state.copy(todo = newTodo))
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
        try {
            if (todoId == null) {
                val newTodo = todo.buildNewTodoModel()
                todoStore.insert(newTodo)
            } else {
                val updatedTodo = todo.buildUpdatedTodoModel()
                todoStore.update(updatedTodo)
            }
            sendState(state.copy(saved = true))
        } catch (error: IllegalStateException) {
            // TODO handle validation issue
        }
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
        val todo: EditTodoUiModel = EditTodoUiModel(),
        val saved: Boolean = false,
        val saveEnabled: Boolean = false,
        val validationErrors: Set<ValidationError> = emptySet()
    )

    sealed class Event {
        object Save : Event()
        class ChangeTitle(val title: String?) : Event()
        class ChangePeriodUnit(val periodUnit: PeriodUnit) : Event()
        class ChangePeriod(val period: Int) : Event()
    }
}