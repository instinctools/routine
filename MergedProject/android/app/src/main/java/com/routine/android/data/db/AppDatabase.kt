package com.routine.android.data.db

import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.routine.MainApplication
import com.routine.android.data.db.entity.TodoEntity

@Database(entities = [TodoEntity::class], version = 1)
@TypeConverters(Converters::class)
abstract class AppDatabase : RoomDatabase() {
    abstract fun todos(): TodoDao
}

private var database: AppDatabase? = null

fun database(): AppDatabase {
    if (database == null) {
        synchronized(AppDatabase::class.java) {
            if (database == null) {
                database = Room.databaseBuilder(MainApplication.getContext(), AppDatabase::class.java, "android-todos.sql")
                    .fallbackToDestructiveMigration()
                    .build()
            }
        }
    }
    return database!!
}