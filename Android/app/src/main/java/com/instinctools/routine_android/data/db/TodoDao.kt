package com.instinctools.routine_android.data.db

import androidx.room.Dao
import androidx.room.Insert
import com.instinctools.routine_android.data.TodoEntity

@Dao
interface TodoDao {

    @Insert
    suspend fun addTodo(todoEntity: TodoEntity)
}