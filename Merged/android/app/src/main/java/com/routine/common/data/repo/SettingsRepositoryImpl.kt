package com.routine.common.data.repo

import com.routine.common.data.datasotre.SettingsDataStore
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class SettingsRepositoryImpl @Inject constructor(private val settingsDataStore: SettingsDataStore) : SettingsRepository {

    override fun isProfilerEnabled(): Flow<Boolean> = settingsDataStore.isProfilerEnabled()

    override fun profilerInterval(): Flow<Long> = settingsDataStore.profilerInterval()
}
