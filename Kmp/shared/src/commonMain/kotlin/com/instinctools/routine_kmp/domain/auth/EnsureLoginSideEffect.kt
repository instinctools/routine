package com.instinctools.routine_kmp.domain.auth

import com.instinctools.routine_kmp.data.auth.AuthRepository
import com.instinctools.routine_kmp.domain.ActionSideEffect
import com.instinctools.routine_kmp.domain.EffectStatus
import kotlinx.coroutines.flow.FlowCollector

class EnsureLoginSideEffect(
    private val authRepository: AuthRepository
) : ActionSideEffect<Unit, Boolean>() {

    override suspend fun FlowCollector<EffectStatus<Boolean>>.doWork(input: Unit) {
        val userId = authRepository.getUserId()
        if (userId == null) {
            authRepository.loginAnonymously()
        }
        emitData(true)
    }
}