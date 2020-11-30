package com.instinctools.routine_kmp.data.firestore

object FirebaseConst {

    object Collection {
        const val users = "users"
        const val todos = "todos"
    }

    object Todo {
        const val FIELD_TITLE = "title"
        const val FIELD_PERIOD_VALUE = "period"
        const val FIELD_PERIOD_UNIT = "periodUnit"
        const val FIELD_PERIOD_STRATEGY = "resetType"
        const val FIELD_TIMESTAMP = "timestamp"
    }
}