package com.routine.android.data.repo

import com.dropbox.android.external.store4.StoreBuilder
import com.dropbox.android.external.store4.valueFetcher
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.routine.android.data.db.entity.TodoEntity
import com.routine.android.data.model.Todo
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.tasks.await

@ExperimentalCoroutinesApi
@FlowPreview
@ExperimentalStdlibApi
object TodosRepository {
    val todosStore = StoreBuilder
        .from(valueFetcher<String, List<Any>> { userId ->
            flow {
                val querySnapshot = Firebase.firestore
                    .collection("users")
                    .document(userId)
                    .collection("todos")
                    .get()
                    .await()

                val list = buildList {
                    for (document in querySnapshot) {
                        add(document.toObject(TodoEntity::class.java))
                    }
                }
                emit(list)
            }
                .map { list -> list.sortedBy { it.timestamp } }
                .map { Todo.from(it) }
        })
        .build()
}