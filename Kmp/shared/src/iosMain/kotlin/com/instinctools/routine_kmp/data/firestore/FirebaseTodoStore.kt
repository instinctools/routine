package com.instinctools.routine_kmp.data.firestore

import com.instinctools.routine_kmp.model.Todo
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

actual class FirebaseTodoStore(
    private val interactor: IosFirestoreInteractor
) {

    actual suspend fun fetchTodos(userId: String): List<Todo> {
        return suspendCancellableCoroutine { continuation ->
            interactor.fetchTodos(userId) { todos, exception ->
                if (exception != null) {
                    continuation.resumeWithException(exception)
                } else if (todos != null) {
                    continuation.resume(todos)
                }
            }
        }
    }

    actual suspend fun deleteTodo(userId: String, todoId: String) {
        return suspendCancellableCoroutine { continuation ->
            interactor.deleteTodo(userId, todoId) { exception ->
                if (exception != null) {
                    continuation.resumeWithException(exception)
                } else {
                    continuation.resume(Unit)
                }
            }
        }
    }

    actual suspend fun addTodo(userId: String, todo: Todo): String {
        return suspendCancellableCoroutine { continuation ->
            interactor.addTodo(userId, todo) { id, exception ->
                if (exception != null) {
                    continuation.resumeWithException(exception)
                } else if (id != null) {
                    continuation.resume(id)
                }
            }
        }
    }

    actual suspend fun updateTodo(userId: String, todo: Todo) {
        return suspendCancellableCoroutine { continuation ->
            interactor.updateTodo(userId, todo) { exception ->
                if (exception != null) {
                    continuation.resumeWithException(exception)
                } else {
                    continuation.resume(Unit)
                }
            }
        }
    }
}