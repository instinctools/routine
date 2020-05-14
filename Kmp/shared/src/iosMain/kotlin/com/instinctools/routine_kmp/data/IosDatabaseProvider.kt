package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.TodoDatabase
import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.drivers.native.NativeSqliteDriver

class IosDatabaseProvider : DatabaseProvider {

    override fun sqlDriver(dbName: String): SqlDriver {
        return NativeSqliteDriver(TodoDatabase.Schema, dbName)
    }
}