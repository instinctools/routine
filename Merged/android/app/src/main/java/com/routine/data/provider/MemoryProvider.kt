package com.routine.data.provider

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.os.Build
import kotlinx.coroutines.InternalCoroutinesApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.isActive
import java.io.RandomAccessFile
import java.util.regex.Pattern
import kotlin.coroutines.coroutineContext

class MemoryProvider(private val activityManager: ActivityManager) {

    private val memoryInfo = ActivityManager.MemoryInfo()

    @SuppressLint("ObsoleteSdkInt")
    @InternalCoroutinesApi
    private fun memoryFlow(delay: Long): Flow<Memory> =
        flow {
            while (coroutineContext.isActive) {
                activityManager.getMemoryInfo(memoryInfo)

                val totalMemory = if (Build.VERSION.SDK_INT > Build.VERSION_CODES.ICE_CREAM_SANDWICH_MR1) {
                    memoryInfo.totalMem
                } else {
                    getTotalRamForOldApi()
                }
                emit(Memory(totalMemory, memoryInfo.availMem, memoryInfo.threshold))
                delay(delay)
            }
        }

    /**
     * Legacy method for old Android
     */
    private fun getTotalRamForOldApi(): Long {
        var reader: RandomAccessFile? = null
        var totRam: Long = -1
        try {
            reader = RandomAccessFile("/proc/meminfo", "r")
            val load = reader.readLine()

            // Get the Number value from the string
            val p = Pattern.compile("(\\d+)")
            val m = p.matcher(load)
            var value = ""
            while (m.find()) {
                value = m.group(1)
            }
            reader.close()

            totRam = value.toLong()
        } catch (e: Exception) {
        } finally {
            reader?.close()
        }

        return totRam * 1024 // bytes
    }
}

data class Memory(
    val totalMemory: Long,
    val availableMemory: Long,
    val threshold: Long
)
