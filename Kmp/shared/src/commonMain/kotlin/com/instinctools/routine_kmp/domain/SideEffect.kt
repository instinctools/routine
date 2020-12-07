package com.instinctools.routine_kmp.domain

import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.FlowCollector
import kotlinx.coroutines.flow.flow

interface SideEffect<Input, Output> {
    fun call(input: Input): Flow<EffectStatus<Output>>
}

abstract class ActionSideEffect<Input, Output> : SideEffect<Input, Output> {

    override fun call(input: Input): Flow<EffectStatus<Output>> = flow {
        try {
            emit(EffectStatus.progress<Output>())
            doWork(input)
        } catch (error: Throwable) {
            if (error is CancellationException) return@flow
            emit(EffectStatus.error<Output>(error))
        }
    }

    protected suspend fun FlowCollector<EffectStatus<Output>>.emitData(output: Output) {
        emit(EffectStatus.data(output))
    }

    protected abstract suspend fun FlowCollector<EffectStatus<Output>>.doWork(input: Input)
}

data class EffectStatus<T>(
    val progress: Boolean = false,
    val done: Boolean = false,
    val data: T? = null,
    val error: Throwable? = null
) {
    companion object {
        fun <T> progress() = EffectStatus<T>(progress = true)
        fun <T> data(data: T) = EffectStatus(data = data)
        fun <T> error(throwable: Throwable) = EffectStatus<T>(error = throwable)
    }
}