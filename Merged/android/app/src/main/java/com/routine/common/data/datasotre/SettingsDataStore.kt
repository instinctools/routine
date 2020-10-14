package com.routine.common.data.datasotre

import kotlinx.coroutines.flow.Flow

interface SettingsDataStore {

    fun isProfilerEnabled(): Flow<Boolean>

    fun profilerInterval(): Flow<Long>
}
