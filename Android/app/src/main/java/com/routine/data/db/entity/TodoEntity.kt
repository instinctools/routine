package com.routine.data.db.entity

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
        val timestamp: Date = Date(),
        val resetType: ResetType = ResetType.BY_PERIOD
)

enum class PeriodUnit {
    DAY,
    WEEK,
    MONTH
}

enum class ResetType{
    BY_PERIOD,
    BY_DATE
}
