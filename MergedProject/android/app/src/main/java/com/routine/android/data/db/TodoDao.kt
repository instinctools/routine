package com.routine.android.data.db

import androidx.room.*
import com.routine.android.data.db.entity.TodoEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface TodoDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun addTodo(todoEntity: TodoEntity)

    @Update
    suspend fun updateTodo(todoEntity: TodoEntity)

    @Query("DELETE FROM todo WHERE id = :id")
    suspend fun deleteTodo(id: String)

    @Query("SELECT * FROM todo")
    fun getTodos(): Flow<List<TodoEntity>>

    @Query("SELECT * FROM todo WHERE id=:id")
    suspend fun getTodo(id: String): TodoEntity

    @Query("DELETE FROM todo")
    suspend fun deleteAll()

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun addTodos(todos: List<TodoEntity>);
}