package com.instinctools.routine_kmp.model.reset

import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.reset.impl.FromNowResetter
import com.instinctools.routine_kmp.model.reset.impl.IntervalBasedResetter

object TodoResetterFactory {

    fun get(periodResetStrategy: PeriodResetStrategy) = when (periodResetStrategy) {
        PeriodResetStrategy.IntervalBased -> IntervalBasedResetter()
        PeriodResetStrategy.FromNow -> FromNowResetter()
    }
}