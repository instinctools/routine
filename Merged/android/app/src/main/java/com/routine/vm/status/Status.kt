package com.routine.vm.status

sealed class Status<out R> {
    object Loading : Status<Nothing>()
    data class Data<R>(val value: R) : Status<R>()
    data class Error(val throwable: Throwable) : Status<Nothing>()
}
