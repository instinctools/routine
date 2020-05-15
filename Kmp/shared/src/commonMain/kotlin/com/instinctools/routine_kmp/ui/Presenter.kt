package com.instinctools.routine_kmp.ui

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancelChildren

abstract class Presenter {

    val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    fun stop() {
        scope.coroutineContext.cancelChildren()
    }
}