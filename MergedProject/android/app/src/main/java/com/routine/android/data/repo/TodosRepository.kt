package com.routine.android.data.repo

import com.dropbox.android.external.store4.SourceOfTruth
import com.dropbox.android.external.store4.StoreBuilder
import com.dropbox.android.external.store4.nonFlowValueFetcher
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.routine.android.data.db.database
import com.routine.android.data.db.entity.TodoEntity
import com.routine.android.userIdOrEmpty
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.tasks.await

@ExperimentalCoroutinesApi
@FlowPreview
@ExperimentalStdlibApi
object TodosRepository {

    val todosStore = StoreBuilder
        .from<String, List<TodoEntity>, List<TodoEntity>>(nonFlowValueFetcher { userId ->
            val querySnapshot = Firebase.firestore
                .collection("users")
                .document(userId)
                .collection("todos")
                .get()
                .await()
            buildList {
                for (document in querySnapshot) {
                    add(document.toObject(TodoEntity::class.java))
                }
            }
        }, SourceOfTruth.from(
                reader = { key ->
                    database().todos()
                        .getTodos()
                },
                writer = { key, input ->
                    database().todos()
                        .addTodos(input)
                },
                delete = { key ->
                    database().todos()
                        .deleteTodo(key)
                },
                deleteAll = {
                    database().todos()
                        .deleteAll()
                }

        ))
        .build()

    val removeTodoStore = StoreBuilder.from(nonFlowValueFetcher<Pair<String, String>, Boolean> {
        Firebase.firestore
            .collection("users")
            .document(it.first)
            .collection("todos")
            .document(it.second)
            .delete()
            .await()
        true
    })
        .disableCache()
        .build()
}


