package com.routine.vm.status.cache

import kotlinx.coroutines.flow.Flow

interface Cache<R> {

    val cache: Flow<R>

    fun run()
}
