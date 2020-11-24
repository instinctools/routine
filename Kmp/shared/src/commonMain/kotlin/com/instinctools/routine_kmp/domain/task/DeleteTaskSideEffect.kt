package com.instinctools.routine_kmp.domain.task

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.SideEffect
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

class DeleteTaskSideEffect(
    private val todoRepository: TodoRepository
) : SideEffect<String, Boolean> {

    override fun call(input: String): Flow<EffectStatus<Boolean>> = flow {
        try {
            emit(EffectStatus.progress())
            todoRepository.delete(input)
            emit(EffectStatus.data(true))
        } catch (error: Throwable) {
            if (error is CancellationException) return@flow
            emit(EffectStatus.error(error))
        }
    }
}