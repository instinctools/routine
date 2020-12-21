package com.instinctools.routine_kmp.data.firestore

import com.google.firebase.Timestamp
import com.google.firebase.firestore.CollectionReference
import com.google.firebase.firestore.QueryDocumentSnapshot
import com.google.firebase.firestore.Source
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.instinctools.routine_kmp.model.PeriodResetStrategy
import com.instinctools.routine_kmp.model.PeriodUnit
import com.instinctools.routine_kmp.model.toFirebaseMap
import com.instinctools.routine_kmp.model.todo.Todo
import com.instinctools.routine_kmp.util.dateFromEpoch
import kotlinx.coroutines.tasks.await

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