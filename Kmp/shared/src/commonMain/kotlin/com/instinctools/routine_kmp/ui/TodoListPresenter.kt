package com.instinctools.routine_kmp.ui

import com.instinctools.routine_kmp.data.TodoStore
import com.instinctools.routine_kmp.model.PeriodType
import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ConflatedBroadcastChannel
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class TodoListPresenter(
    private val todoStore: TodoStore
) : Presenter<TodoListPresenter.State, TodoListPresenter.Event>() {

    private val _states = ConflatedBroadcastChannel<State>()
    override val states: ReceiveChannel<State> get() = _states.openSubscription()

    private val _events = Channel<Event>(Channel.RENDEZVOUS)
    override val events: SendChannel<Event> get() = _events

    fun start() {
        var state = State(emptyList())
        fun sendState(newState: State) {
            state = newState
            _states.offer(newState)
        }

//        todoStore.getTodos()
//            .flowOn(Dispatchers.Default)
//            .onEach { uiUpdater(it) }
//            .launchIn(scope)

        flow {
            val todos = listOf(
                Todo(1, "First", PeriodType.WEEKLY, 2, 0),
                Todo(2, "Next", PeriodType.DAILY, 3, 0),
                Todo(3, "One more", PeriodType.MONTHLY, 1, 0),
                Todo(4, "Last", PeriodType.WEEKLY, 2, 0)
            )
            emit(todos)
        }
            .onEach {
                val newState = state.copy(items = it)
                sendState(newState)
            }
            .launchIn(scope)
    }

    sealed class Event {

    }

    data class State(
        val items: List<Todo>
    )
}