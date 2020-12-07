package com.instinctools.routine_kmp.model

import com.instinctools.routine_kmp.data.firestore.FirebaseConst
import com.instinctools.routine_kmp.model.todo.Todo

fun Todo.toFirebaseMap(): Map<String, Any> = mapOf(
    FirebaseConst.Todo.FIELD_TITLE to title,
    FirebaseConst.Todo.FIELD_PERIOD_UNIT to periodUnit.id,
    FirebaseConst.Todo.FIELD_PERIOD_VALUE to periodValue,
    FirebaseConst.Todo.FIELD_PERIOD_STRATEGY to periodStrategy.id,
    FirebaseConst.Todo.FIELD_TIMESTAMP to nextDate
)