package com.routine.data.db

import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.routine.App
import com.routine.data.db.entity.TodoEntity

@Database(entities = [TodoEntity::class], version = 2)
@TypeConverters(Converters::class)
abstract class AppDatabase : RoomDatabase() {
    abstract fun todos(): TodoDao
}

private var database: AppDatabase? = null

fun database(): AppDatabase {
    if (database == null) {
        synchronized(AppDatabase::class.java) {
            if (database == null) {
                database = Room.databaseBuilder(App.CONTEXT, AppDatabase::class.java, "android-todos.sql")
                    .fallbackToDestructiveMigration()
                    .build()
            }
        }
    }
    return database!!
}
