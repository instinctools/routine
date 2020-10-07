package com.routine.data.provider

import android.annotation.SuppressLint
import android.os.Build
import kotlinx.coroutines.InternalCoroutinesApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.isActive
import java.io.File
import java.io.FileFilter
import java.io.RandomAccessFile
import java.util.regex.Pattern
import kotlin.coroutines.coroutineContext

private const val CPU_INFO_DIR = "/sys/devices/system/cpu/"

@SuppressLint("ObsoleteSdkInt")
class CpuProvider {

    @InternalCoroutinesApi
    fun cpuFlow(delay: Long): Flow<List<CpuCore>> =
        flow {
            val numberCores = getNumberOfCores()
            val cores = mutableListOf<CpuCore>()
            while (coroutineContext.isActive) {
                for (i in 0 until numberCores) {
                    val (minFreq, maxFreq) = getMinMaxFreq(i)
                    cores.add(CpuCore(minFreq, maxFreq, getCurrentFreq(i)))
                }
                emit(cores)
                delay(delay)
            }
        }

    private fun getNumberOfCores(): Int {
        return if (Build.VERSION.SDK_INT >= 17) {
            Runtime.getRuntime().availableProcessors()
        } else {
            getNumCoresLegacy()
        }
    }

    /**
     * Checking frequencies directories and return current value if exists (otherwise we can
     * assume that core is stopped - value -1)
     */
    private fun getCurrentFreq(coreNumber: Int): Long {
        val currentFreqPath = "${CPU_INFO_DIR}cpu$coreNumber/cpufreq/scaling_cur_freq"
        return try {
            RandomAccessFile(currentFreqPath, "r").use { it.readLine().toLong() / 1000 }
        } catch (e: Exception) {
            -1
        }
    }

    /**
     * Read max/min frequencies for specific [coreNumber]. Return [Pair] with min and max frequency
     * or [Pair] with -1.
     */
    private fun getMinMaxFreq(coreNumber: Int): Pair<Long, Long> {
        val minPath = "${CPU_INFO_DIR}cpu$coreNumber/cpufreq/cpuinfo_min_freq"
        val maxPath = "${CPU_INFO_DIR}cpu$coreNumber/cpufreq/cpuinfo_max_freq"
        return try {
            val minMhz = RandomAccessFile(minPath, "r").use { it.readLine().toLong() / 1000 }
            val maxMhz = RandomAccessFile(maxPath, "r").use { it.readLine().toLong() / 1000 }
            Pair(minMhz, maxMhz)
        } catch (e: Exception) {
            Pair(-1, -1)
        }
    }

    /**
     * Gets the number of cores available in this device, across all processors.
     * Requires: Ability to peruse the filesystem at "/sys/devices/system/cpu"
     *
     * @return The number of cores, or 1 if check fails
     */
    private fun getNumCoresLegacy(): Int {
        class CpuFilter : FileFilter {
            override fun accept(pathname: File): Boolean {
                // Check if filename is "cpu", followed by a single digit number
                if (Pattern.matches("cpu[0-9]+", pathname.name)) {
                    return true
                }
                return false
            }
        }
        return try {
            val dir = File(CPU_INFO_DIR)
            val files = dir.listFiles(CpuFilter())
            files.size
        } catch (e: Exception) {
            1
        }
    }
}

data class CpuCore(
    val minFreq: Long,
    val maxFreq: Long,
    val currentFreq: Long
)
