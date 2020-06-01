package com.instinctools.routine_kmp.data

import android.content.Context
import com.instinctools.routine_kmp.TodoDatabase
import com.instinctools.routine_kmp.data.database.DatabaseProvider
import com.squareup.sqldelight.android.AndroidSqliteDriver
import com.squareup.sqldelight.db.SqlDriver

class AndroidDatabaseProvider(
    private val context: Context
) : DatabaseProvider {

    override fun sqlDriver(dbName: String): SqlDriver {
        return AndroidSqliteDriver(TodoDatabase.Schema, context, dbName)
    }
}