package com.routine.vm.status.cache

interface ParamCache<T, R> : Cache<R> {

    fun run(value: T)

}
