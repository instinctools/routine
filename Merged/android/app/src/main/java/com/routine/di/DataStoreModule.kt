package com.routine.di

import android.content.Context
import androidx.datastore.DataStore
import androidx.datastore.preferences.Preferences
import androidx.datastore.preferences.preferencesKey
import androidx.preference.PreferenceDataStore
import com.routine.R
import com.routine.common.data.datasotre.PreferenceDataStoreImpl
import com.routine.common.data.datasotre.SettingsDataStore
import com.routine.common.data.datasotre.SettingsDataStoreImpl
import dagger.Binds
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ApplicationComponent
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Singleton

@Module
@InstallIn(ApplicationComponent::class)
abstract class DataStoreModule {

    @Binds
    @Singleton
    abstract fun bindPreferenceDataStore(preferenceDataStore: PreferenceDataStoreImpl): PreferenceDataStore

    companion object{

        @Provides
        @Singleton
        fun providesSettingsDataStore(@ApplicationContext context: Context, dataStore: DataStore<Preferences>): SettingsDataStore {
            return SettingsDataStoreImpl(
                    dataStore,
                    preferencesKey(context.getString(R.string.settings_key_profiler_enabled)),
                    preferencesKey(context.getString(R.string.settings_key_profiler_interval)),
                    context.getString(R.string.settings_profiler_interval_def_value).toLong())
        }
    }
}
