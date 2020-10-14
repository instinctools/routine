package com.routine.common.data.datasotre

import androidx.datastore.DataStore
import androidx.datastore.preferences.Preferences
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class SettingsDataStoreImpl @Inject constructor(
        private val dataStore: DataStore<Preferences>,
        private val keyProfilerEnabled: Preferences.Key<Boolean>,
        private val keyProfilerInterval: Preferences.Key<String>,
        private val defInterval: Long

) : SettingsDataStore {

    override fun isProfilerEnabled(): Flow<Boolean> =
        dataStore.data.map {
            it[keyProfilerEnabled] ?: false
        }

    override fun profilerInterval(): Flow<Long> =
        dataStore.data.map {
            val interval = it[keyProfilerInterval]
            if (interval == null){
                defInterval
            } else {
                interval.toLong()
            }
        }
}
