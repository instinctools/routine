package com.routine.common.data.repo

import kotlinx.coroutines.flow.Flow

interface SettingsRepository {

    fun isProfilerEnabled(): Flow<Boolean>

    fun profilerInterval(): Flow<Long>
}
