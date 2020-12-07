package com.instinctools.routine_kmp.util

open class OneTimeEvent<out T>(private val content: T? = null) {

    var isConsumed = false
        private set

    fun consumeContent(): T? = if (isConsumed) null else content.also {
        isConsumed = true
    }

    fun forceContent(): T? = content
}

inline fun <T> OneTimeEvent<T>.consumeOneTimeEvent(consumer: (T) -> Unit) {
    val content = consumeContent() ?: return
    consumer(content)
}
