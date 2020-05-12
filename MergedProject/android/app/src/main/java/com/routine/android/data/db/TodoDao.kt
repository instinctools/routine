package com.routine.android.data.db

import androidx.lifecycle.LiveData
import androidx.room.*
import com.routine.android.data.db.entity.TodoEntity

@Dao
interface TodoDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun addTodo(todoEntity: TodoEntity)

    @Update
    suspend fun updateTodo(todoEntity: TodoEntity)

    @Query("DELETE FROM todo WHERE id = :id")
    suspend fun deleteTodo(id: String)

    @Query("SELECT * FROM todo")
    fun getTodos(): LiveData<List<TodoEntity>>

    @Query("SELECT * FROM todo WHERE id=:id")
    suspend fun getTodo(id: String): TodoEntity
}