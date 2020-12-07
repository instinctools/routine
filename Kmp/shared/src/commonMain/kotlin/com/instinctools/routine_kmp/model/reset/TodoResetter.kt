package com.instinctools.routine_kmp.model.reset

import com.instinctools.routine_kmp.model.todo.Todo

interface TodoResetter {
    fun reset(todo: Todo): Todo
}