package com.routine.data.provider

import android.util.Log
import android.view.Choreographer
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.cancel
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.sendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.isActive
import java.util.concurrent.TimeUnit
import kotlin.math.roundToInt

class FpsProvider {

    private val choreographer = Choreographer.getInstance()

    @ExperimentalCoroutinesApi
    fun fpsFlow(interval: Long): Flow<HardwareInfo.Fps> =
        callbackFlow {
            var frameStartTime = 0L
            var framesRendered = 0L

            val frameCallback = object : Choreographer.FrameCallback {
                override fun doFrame(frameTimeNanos: Long) {
                    val currentTimeMillis = TimeUnit.NANOSECONDS.toMillis(frameTimeNanos)
                    if (frameStartTime > 0) {
                        // take the span in milliseconds
                        val timeSpan: Long = currentTimeMillis - frameStartTime
                        framesRendered++
                        if (timeSpan > interval) {
                            val fps = framesRendered * 1000 / timeSpan.toFloat()
                            frameStartTime = currentTimeMillis
                            framesRendered = 0

                            if (coroutineContext.isActive){
                                sendBlocking(HardwareInfo.Fps(fps.roundToInt()))
                            }
                        }
                    } else {
                        frameStartTime = currentTimeMillis
                    }

                    choreographer.postFrameCallback(this)
                }
            }
            choreographer.postFrameCallback(frameCallback)
            awaitClose { cancel() }
        }
}
