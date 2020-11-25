package com.instinctools.routine_kmp.domain.task

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.domain.ActionSideEffect
import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.task.ResetTaskSideEffect.Input
import com.instinctools.routine_kmp.model.reset.TodoResetterFactory
import kotlinx.coroutines.flow.FlowCollector

class ResetTaskSideEffect(
    private val todoRepository: TodoRepository
) : ActionSideEffect<Input, Boolean>() {

    data class Input(
        val taskId: String
    )

    override suspend fun FlowCollector<EffectStatus<Boolean>>.doWork(input: Input) {
        val todo = requireNotNull(todoRepository.getTodoById(input.taskId)) { "Failed to load todo with id=${input.taskId}" }
        val resetter = TodoResetterFactory.get(todo.periodStrategy)
        val resetTodo = resetter.reset(todo)

        todoRepository.update(resetTodo)
        emitData(true)
    }
}