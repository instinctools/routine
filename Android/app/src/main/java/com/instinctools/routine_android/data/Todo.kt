package com.instinctools.routine_android.data

data class Todo(
        val id: Int,
        val title: String = "TEST123",
        val periodStr: String = "Every day",
        val periodDate: String = "Tomorrow"
)