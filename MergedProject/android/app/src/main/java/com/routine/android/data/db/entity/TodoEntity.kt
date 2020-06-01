package com.routine.android.data.db.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.*

@Entity(tableName = "todo")
data class TodoEntity(
        @PrimaryKey
        val id: String = "",
        val title: String = "",
        val period: Int = 1,
        val periodUnit: PeriodUnit = PeriodUnit.DAY,
        val timestamp: Date = Date()
)

enum class PeriodUnit {
    DAY,
    WEEK,
    MONTH
}