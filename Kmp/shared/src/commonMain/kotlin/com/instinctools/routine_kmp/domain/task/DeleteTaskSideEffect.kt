package com.instinctools.routine_kmp.domain.task

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.domain.ActionSideEffect
import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.task.DeleteTaskSideEffect.Input
import kotlinx.coroutines.flow.FlowCollector

class DeleteTaskSideEffect(
    private val todoRepository: TodoRepository
) : ActionSideEffect<Input, Boolean>() {

    data class Input(
        val taskId: String
    )

    override suspend fun FlowCollector<EffectStatus<Boolean>>.doWork(input: Input) {
        todoRepository.delete(input.taskId)
        emit(EffectStatus.data(true))
    }
}