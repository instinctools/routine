package com.instinctools.routine_kmp.model.reset

import com.instinctools.routine_kmp.model.Todo

interface TodoResetter {
    fun reset(todo: Todo): Todo
}