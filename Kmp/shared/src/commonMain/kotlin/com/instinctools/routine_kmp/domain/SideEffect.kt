package com.instinctools.routine_kmp.domain

import kotlinx.coroutines.flow.Flow

interface SideEffect<Input, Output> {
    fun call(input: Input): Flow<EffectStatus<Output>>
}

data class EffectStatus<T>(
    val progress: Boolean = false,
    val data: T? = null,
    val error: Throwable? = null
) {
    companion object {
        fun <T> progress() = EffectStatus<T>(progress = true)
        fun <T> data(data: T) = EffectStatus(data = data)
        fun <T> error(throwable: Throwable) = EffectStatus<T>(error = throwable)
    }
}

class SideEffectTrigger<Input, Output, Action, State>(
    val sideEffect: SideEffect<Input, Output>,
    val triggerActions: Array<Action>,
    val inputCreator: (Action, State) -> Input?,
    val outputCreator: (EffectStatus<Output>) -> Action
)