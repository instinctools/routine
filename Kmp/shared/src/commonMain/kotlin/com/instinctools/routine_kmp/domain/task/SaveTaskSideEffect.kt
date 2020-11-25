package com.instinctools.routine_kmp.domain.task

import com.instinctools.routine_kmp.util.OneTimeEvent
import kotlinx.coroutines.CancellationException

class SaveTaskSideEffect {

    private suspend fun trySave() {
        val todo = state.todo
        try {
            if (todoId == null) {
                val newTodo = todo.buildNewTodoModel()
                todoRepository.add(newTodo)
            } else {
                val updatedTodo = todo.buildUpdatedTodoModel()
                todoRepository.update(updatedTodo)
            }
            sendState(state.copy(saved = true))
        } catch (error: Throwable) {
            if (error is CancellationException) return
            sendState(state.copy(saveError = OneTimeEvent(error)))
        }
    }
}