package com.routine.android.data.db

import androidx.room.TypeConverter
import com.routine.android.data.db.entity.PeriodUnit
import java.util.*

class Converters {

    @TypeConverter
    fun fromPeriodUnit(period: PeriodUnit) = period.name

    @TypeConverter
    fun toPeriodUnit(value: String) = enumValueOf<PeriodUnit>(value)

    @TypeConverter
    fun fromTimestamp(value: Long) = Date(value)

    @TypeConverter
    fun dateToTimestamp(date: Date) = date.time
}