package com.instinctools.routine_kmp.domain.task

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.domain.ActionSideEffect
import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.model.todo.EditableTodo
import com.instinctools.routine_kmp.model.todo.toExistingTodo
import com.instinctools.routine_kmp.model.todo.toNewTodo
import kotlinx.coroutines.flow.FlowCollector

class SaveTaskSideEffect(
    private val todoRepository: TodoRepository
) : ActionSideEffect<SaveTaskSideEffect.Input, Boolean>() {

    data class Input(val task: EditableTodo)

    override suspend fun FlowCollector<EffectStatus<Boolean>>.doWork(input: Input) {
        val task = input.task
        if (task.id == null) {
            val newTodo = task.toNewTodo()
            todoRepository.add(newTodo)
        } else {
            val updatedTodo = task.toExistingTodo()
            todoRepository.update(updatedTodo)
        }
        emitData(true)
    }
}