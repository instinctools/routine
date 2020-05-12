package com.routine.android.data.db.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.*

@Entity(tableName = "todo")
data class TodoEntity(
        @PrimaryKey
        val id: String,
        val title: String,
        val period: Int,
        val periodUnit: PeriodUnit,
        val timestamp: Date
)

enum class PeriodUnit {
    DAY,
    WEEK,
    MONTH
}