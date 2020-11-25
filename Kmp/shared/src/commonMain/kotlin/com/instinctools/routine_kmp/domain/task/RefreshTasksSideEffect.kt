package com.instinctools.routine_kmp.domain.task

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.domain.ActionSideEffect
import com.instinctools.routine_kmp.domain.EffectStatus
import kotlinx.coroutines.flow.FlowCollector

class RefreshTasksSideEffect(
    private val todoRepository: TodoRepository
) : ActionSideEffect<Unit, Boolean>() {

    override suspend fun FlowCollector<EffectStatus<Boolean>>.doWork(input: Unit) {
        todoRepository.refresh()
        emit(EffectStatus.data(true))
    }
}