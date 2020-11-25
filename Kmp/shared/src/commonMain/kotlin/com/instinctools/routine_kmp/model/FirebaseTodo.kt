package com.instinctools.routine_kmp.model

import com.instinctools.routine_kmp.data.firestore.FirebaseConst
import com.instinctools.routine_kmp.model.todo.Todo

fun Todo.toFirebaseMap(): Map<String, Any> = mapOf(
    FirebaseConst.Todo.title to title,
    FirebaseConst.Todo.periodInit to periodUnit.id,
    FirebaseConst.Todo.periodValue to periodValue,
    FirebaseConst.Todo.periodStrategy to periodStrategy.id,
    FirebaseConst.Todo.nextTimestamp to nextTimestamp
)