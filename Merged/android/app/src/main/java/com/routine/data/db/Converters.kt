package com.routine.data.db

import androidx.room.TypeConverter
import com.routine.data.db.entity.PeriodUnit
import com.routine.data.db.entity.ResetType
import java.util.*

class Converters {

    @TypeConverter
    fun fromPeriodUnit(period: PeriodUnit) = period.name

    @TypeConverter
    fun toPeriodUnit(value: String) = enumValueOf<PeriodUnit>(value)

    @TypeConverter
    fun fromResetType(resetType: ResetType) = resetType.name

    @TypeConverter
    fun toResetType(value: String) = enumValueOf<ResetType>(value)

    @TypeConverter
    fun fromTimestamp(value: Long) = Date(value)

    @TypeConverter
    fun dateToTimestamp(date: Date) = date.time
}
