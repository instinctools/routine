package com.routine.data.provider

import android.view.Choreographer
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.cancel
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.sendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import java.util.concurrent.TimeUnit

class FpsProvider {

    private val choreographer = Choreographer.getInstance()

    @ExperimentalCoroutinesApi
    fun fpsFlow(interval: Long): Flow<Double> =
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
                            val fps: Double = framesRendered * 1000 / timeSpan.toDouble()
                            frameStartTime = currentTimeMillis
                            framesRendered = 0
                            sendBlocking(fps)
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
