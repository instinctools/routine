package com.instinctools.routine_kmp.model.reset

import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.reset.impl.FromNowResetter
import com.instinctools.routine_kmp.model.reset.impl.FromNextEventResetter

object TodoResetterFactory {

    fun get(periodResetStrategy: PeriodResetStrategy) = when (periodResetStrategy) {
        PeriodResetStrategy.FromNextEvent -> FromNextEventResetter()
        PeriodResetStrategy.FromNow -> FromNowResetter()
    }
}