package com.routine.data.provider

import kotlin.math.roundToInt

sealed class HardwareInfo {
    data class Cpu(
        val cpuCores: List<CpuCore>
    ) : HardwareInfo() {

        val cpuUsagePercent by lazy {
            var totalCpuUsage = 0f
            for (core in cpuCores) {
                totalCpuUsage += ((core.currentFreq - core.minFreq) / (core.maxFreq - core.minFreq).toFloat() * 100)
            }
            val cpuUsage = totalCpuUsage / cpuCores.size
            if (cpuUsage.isNaN()) 0 else cpuUsage.roundToInt()
        }
    }

    data class Memory(
        val totalMemory: Long,
        val availableMemory: Long,
        val threshold: Long
    ) : HardwareInfo() {
        val memoryInUseMb by lazy {
            ((totalMemory - availableMemory) / (1024.0 * 1024.0)).roundToInt()
        }
    }

    data class Fps(val fps: Int) : HardwareInfo()
}
