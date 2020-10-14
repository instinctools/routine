package com.routine.common.data.datasotre

import androidx.datastore.DataStore
import androidx.datastore.preferences.Preferences
import androidx.datastore.preferences.edit
import androidx.datastore.preferences.preferencesKey
import androidx.preference.PreferenceDataStore
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import javax.inject.Inject

class PreferenceDataStoreImpl @Inject constructor(private val dataStore: DataStore<Preferences>) : PreferenceDataStore() {

    override fun putBoolean(key: String, value: Boolean) {
        GlobalScope.launch {
            dataStore.edit { settings ->
                val prefKey = preferencesKey<Boolean>(key)
                settings[prefKey] = value
            }
        }
    }

    override fun getBoolean(key: String, defValue: Boolean): Boolean {
        val prefKey = preferencesKey<Boolean>(key)
        return runBlocking {
            dataStore.data.first()[prefKey] ?: defValue
        }
    }

    override fun putString(key: String, value: String?) {
        GlobalScope.launch {
            dataStore.edit { settings ->
                val prefKey = preferencesKey<String>(key)
                settings[prefKey] = value ?: ""
            }
        }
    }

    override fun getString(key: String, defValue: String?): String? {
        val prefKey = preferencesKey<String>(key)
        return runBlocking {
            dataStore.data.first()[prefKey] ?: defValue
        }
    }
}
