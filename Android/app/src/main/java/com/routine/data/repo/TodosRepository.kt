package com.routine.data.repo

import com.dropbox.android.external.store4.*
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.routine.common.calculateTimestamp
import com.routine.common.userIdOrEmpty
import com.routine.data.db.database
import com.routine.data.db.entity.TodoEntity
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.tasks.await

@ExperimentalCoroutinesApi
@FlowPreview
@ExperimentalStdlibApi
object TodosRepository {

    val todosStore = StoreBuilder
        .from<Pair<String, Boolean>, List<TodoEntity>, List<TodoEntity>>(nonFlowValueFetcher { pair ->
            val result =
                Firebase.firestore
                    .collection("users")
                    .document(Firebase.auth.userIdOrEmpty())
                    .collection("todos")
                    .apply {
                        if (pair.first.isNotEmpty()) {
                            document(pair.first)
                        }
                    }
                    .get()
                    .await()

            buildList {
                for (document in result) {
                    add(document.toObject(TodoEntity::class.java))
                }
            }
        }, SourceOfTruth.from(
                reader = {
                    database().todos()
                        .getTodos()
                },
                writer = { pair, input ->
                    if (pair.second){
                        database().todos()
                            .replaceAll(input)
                    } else {
                        database().todos()
                            .addTodos(input)
                    }
                },
                delete = { pair ->
                    database().todos()
                        .deleteTodo(pair.first)
                },
                deleteAll = {
                    database().todos()
                        .deleteAll()
                }

        ))
        .build()

    val removeTodoStore = StoreBuilder.from(nonFlowValueFetcher<String, Boolean> {
        Firebase.firestore
            .collection("users")
            .document(Firebase.auth.userIdOrEmpty())
            .collection("todos")
            .document(it)
            .delete()
            .await()

        todosStore.clear(Pair(it, false))
        true
    })
        .disableCache()
        .build()

    val resetTodoStore = StoreBuilder.from(nonFlowValueFetcher<String, Boolean> {
        val todoEntity = database().todos()
            .getTodo(it).apply {
                copy(timestamp = calculateTimestamp(
                    period,
                    periodUnit
                )
                )
            }

        Firebase.firestore
            .collection("users")
            .document(Firebase.auth.userIdOrEmpty())
            .collection("todos")
            .document(it)
            .set(todoEntity)
            .await()

        todosStore.fresh(Pair(it, false))
        true
    })
        .disableCache()
        .build()

    val getTodoStore = StoreBuilder.from(nonFlowValueFetcher<String, TodoEntity> {
        if (it.isNotEmpty()) {
            database().todos().getTodo(it)
        } else {
            TodoEntity()
        }
    })
        .disableCache()
        .build()

    val addTodoStore = StoreBuilder.from(nonFlowValueFetcher<TodoEntity, Boolean> {
        Firebase.firestore.collection("users")
            .document(Firebase.auth.userIdOrEmpty())
            .collection("todos")
            .document(it.id)
            .set(it)
            .await()
        todosStore.fresh(Pair(it.id, false))
        true
    })
        .disableCache()
        .build()
}


