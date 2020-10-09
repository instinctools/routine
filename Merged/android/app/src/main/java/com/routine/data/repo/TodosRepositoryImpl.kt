package com.routine.data.repo

import com.dropbox.android.external.store4.Fetcher
import com.dropbox.android.external.store4.SourceOfTruth
import com.dropbox.android.external.store4.StoreBuilder
import com.dropbox.android.external.store4.fresh
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.routine.App
import com.routine.common.calculateTimestamp
import com.routine.common.userIdOrEmpty
import com.routine.data.db.database
import com.routine.data.db.entity.TodoEntity
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withTimeout
import org.joda.time.DateTime
import javax.inject.Inject

@ExperimentalCoroutinesApi
@FlowPreview
@ExperimentalStdlibApi
class TodosRepositoryImpl @Inject constructor(): TodosRepository {

    override val loginStore = StoreBuilder.from<Any, Boolean>(Fetcher.of {
        if (Firebase.auth.currentUser == null) {
            Firebase.auth
                .signInAnonymously()
                .awaitTimeout()
        }
        true
    })
        .disableCache()
        .build()

    override val todosStore = StoreBuilder
        .from<Pair<String, Boolean>, List<TodoEntity>, List<TodoEntity>>(Fetcher.of { pair ->
            val result = Firebase.firestore
                .collection("users")
                .document(Firebase.auth.userIdOrEmpty())
                .collection("todos")
                .apply {
                    if (pair.first.isNotEmpty()) {
                        document(pair.first)
                    }
                }
                .get()
                .awaitTimeout()

            buildList {
                for (document in result) {
                    add(document.toObject(TodoEntity::class.java))
                }
            }
        }, SourceOfTruth.of(
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

    override val removeTodoStore = StoreBuilder.from(Fetcher.of<String, Boolean> {
        Firebase.firestore
            .collection("users")
            .document(Firebase.auth.userIdOrEmpty())
            .collection("todos")
            .document(it)
            .delete()

        todosStore.clear(Pair(it, false))
        App.scheduleNotification.cancelReminder(it)
        true
    })
        .disableCache()
        .build()

    override val resetTodoStore = StoreBuilder.from(Fetcher.of<String, Boolean> {
        val todoEntity = database().todos().getTodo(it)

        val newtodoEntity = todoEntity.run { copy(timestamp = calculateTimestamp(period, periodUnit, resetType, timestamp)) }

        if (todoEntity == newtodoEntity) {
            return@of true
        }

        Firebase.firestore
            .collection("users")
            .document(Firebase.auth.userIdOrEmpty())
            .collection("todos")
            .document(it)
            .set(newtodoEntity)

        todosStore.fresh(Pair(it, false))
        App.scheduleNotification.addReminder(newtodoEntity.id, newtodoEntity.title, newtodoEntity.timestamp.time)
        true
    })
        .disableCache()
        .build()

    override val getTodoStore = StoreBuilder.from(Fetcher.of<String, TodoEntity> {
        if (it.isNotEmpty()) {
            database().todos().getTodo(it)
        } else {
            TodoEntity()
        }
    })
        .disableCache()
        .build()

    override val addTodoStore = StoreBuilder.from(Fetcher.of<TodoEntity, Boolean> {
        Firebase.firestore.collection("users")
            .document(Firebase.auth.userIdOrEmpty())
            .collection("todos")
            .document(it.id)
            .set(it)
        todosStore.fresh(Pair(it.id, false))
        App.scheduleNotification.addReminder(it.id, it.title, it.timestamp.time)
        true
    })
        .disableCache()
        .build()
}

suspend fun <T> Task<T>.awaitTimeout(): T = withTimeout(10000L) { await() }


