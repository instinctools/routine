package com.instinctools.routine_kmp.data.firestore

import com.google.firebase.Timestamp
import com.google.firebase.firestore.CollectionReference
import com.google.firebase.firestore.QueryDocumentSnapshot
import com.google.firebase.firestore.Source
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.todo.Todo
import com.instinctools.routine_kmp.util.dateFromEpoch
import com.instinctools.routine_kmp.util.timestampSystemTimeZone
import kotlinx.coroutines.tasks.await
import java.util.*

actual class FirebaseTodoStore {

    private val mapper: (QueryDocumentSnapshot) -> Todo = { document ->
        val id = document.id
        val title = document.get(FirebaseConst.Todo.FIELD_TITLE) as String

        val periodUnitId = document.get(FirebaseConst.Todo.FIELD_PERIOD_UNIT) as String
        val periodUnit = PeriodUnit.find(periodUnitId)
        val periodValue = document.get(FirebaseConst.Todo.FIELD_PERIOD_VALUE) as Long

        val resetStrategyId = document.get(FirebaseConst.Todo.FIELD_PERIOD_STRATEGY) as String
        val resetStrategy = PeriodResetStrategy.find(resetStrategyId)
        val nextTimestamp = document.get(FirebaseConst.Todo.FIELD_TIMESTAMP) as Timestamp

        Todo(id, title, periodUnit, periodValue.toInt(), resetStrategy, dateFromEpoch(nextTimestamp.seconds))
    }

    fun Todo.toFirebaseMap(): Map<String, Any> = mapOf(
        FirebaseConst.Todo.FIELD_TITLE to title,
        FirebaseConst.Todo.FIELD_PERIOD_UNIT to periodUnit.id,
        FirebaseConst.Todo.FIELD_PERIOD_VALUE to periodValue,
        FirebaseConst.Todo.FIELD_PERIOD_STRATEGY to periodStrategy.id,
        FirebaseConst.Todo.FIELD_TIMESTAMP to Timestamp(Date(nextDate.timestampSystemTimeZone))
    )

    actual suspend fun fetchTodos(userId: String): List<Todo> {
        val todosTask = todosCollection(userId).get(Source.SERVER)
        return todosTask.await().map(mapper)
    }

    actual suspend fun deleteTodo(userId: String, todoId: String) {
        val todoDocument = todosCollection(userId).document(todoId).get(Source.SERVER).await()
        todoDocument.reference.delete().await()
    }

    actual suspend fun addTodo(userId: String, todo: Todo): String {
        val document = todosCollection(userId).document().get(Source.SERVER).await()
        document.reference.set(todo.toFirebaseMap()).await()
        return document.id
    }

    actual suspend fun updateTodo(userId: String, todo: Todo) {
        val todoDocument = todosCollection(userId).document(todo.id).get(Source.SERVER).await()
        todoDocument.reference.set(todo.toFirebaseMap()).await()
    }

    private fun todosCollection(userId: String): CollectionReference {
        return Firebase.firestore.collection(FirebaseConst.Collection.users)
            .document(userId)
            .collection(FirebaseConst.Collection.todos)
    }
}