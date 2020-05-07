package com.instinctools.routine_android.data.db

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import com.instinctools.routine_android.data.db.entity.TodoEntity

@Dao
interface TodoDao {

    @Insert
    suspend fun addTodo(todoEntity: TodoEntity)

    @Query("SELECT * FROM todo")
    fun getTodos(): LiveData<List<TodoEntity>>
}