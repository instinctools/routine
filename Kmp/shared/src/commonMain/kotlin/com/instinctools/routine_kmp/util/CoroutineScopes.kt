package com.instinctools.routine_kmp.util

import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancelChildren

fun CoroutineScope.cancelChildren(cause: CancellationException? = null) = coroutineContext.cancelChildren(cause)