package com.instinctools.routine_android.data.db

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Update
import com.instinctools.routine_android.data.db.entity.TodoEntity

@Dao
interface TodoDao {

    @Insert
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