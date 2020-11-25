package com.instinctools.routine_kmp.domain.task

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.domain.ActionSideEffect
import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.task.GetTaskByIdSideEffect.Input
import com.instinctools.routine_kmp.domain.task.GetTaskByIdSideEffect.Output
import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.flow.FlowCollector

class GetTaskByIdSideEffect(
    private val todoRepository: TodoRepository
) : ActionSideEffect<Input, Output>() {

    data class Input(val taskId: String)
    data class Output(val task: Todo)

    override suspend fun FlowCollector<EffectStatus<Output>>.doWork(input: Input) {
        val task = todoRepository.getTodoById(input.taskId)
        checkNotNull(task) { "No task with id=${input.taskId} found" }
        emitData(Output(task))
    }
}