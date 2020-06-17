package com.instinctools.routine_kmp.data.firestore

object FirebaseConst {

    object Collection {
        const val users = "users"
        const val todos = "todos"
    }

    object Todo {
        const val title = "title"
        const val periodInit = "period_unit"
        const val periodValue = "period_value"
        const val periodStrategy = "period_strategy"
        const val nextTimestamp = "next_timestamp"
    }
}