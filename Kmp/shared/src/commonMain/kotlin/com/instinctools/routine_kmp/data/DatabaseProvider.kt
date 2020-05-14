package com.instinctools.routine_kmp.data

import com.instinctools.routine_kmp.TodoDatabase
import com.squareup.sqldelight.db.SqlDriver

interface DatabaseProvider {

    fun sqlDriver(dbName: String): SqlDriver

    fun database(): TodoDatabase {
        val driver = sqlDriver("routine.db")
        return TodoDatabase(driver)
    }
}