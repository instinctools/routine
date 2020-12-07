package com.instinctools.routine_kmp.domain.task

import com.instinctools.routine_kmp.data.TodoRepository
import com.instinctools.routine_kmp.domain.EffectStatus
import com.instinctools.routine_kmp.domain.SideEffect
import com.instinctools.routine_kmp.domain.task.GetTasksSideEffect.Output
import com.instinctools.routine_kmp.model.color.ColorEvaluator
import com.instinctools.routine_kmp.model.color.TodoColor
import com.instinctools.routine_kmp.model.todo.Todo
import com.instinctools.routine_kmp.ui.todo.list.TodoListUiModel
import com.instinctools.routine_kmp.util.currentDate
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.datetime.DateTimeUnit
import kotlinx.datetime.until

class GetTasksSideEffect(
    private val todoRepository: TodoRepository
) : SideEffect<Unit, Output> {

    data class Output(
        val expiredTodos: List<TodoListUiModel>,
        val futureTodos: List<TodoListUiModel>,
    )

    override fun call(input: Unit): Flow<EffectStatus<Output>> {
        return todoRepository.getTodosSortedByDate()
            .map {
                val output = toOutput(it)
                EffectStatus.data(output)
            }
    }

    private fun toOutput(todos: List<Todo>): Output {
        val expiredTodos = mutableListOf<TodoListUiModel>()
        val futureTodos = mutableListOf<TodoListUiModel>()

        val todosCount = todos.count()
        val currentDate = currentDate()
        todos.forEachIndexed { index, todo ->
            val todoDate = todo.nextDate
            if (todoDate < currentDate) {
                val daysLeft = todoDate.until(currentDate, DateTimeUnit.DAY)
                expiredTodos += TodoListUiModel(todo, TodoColor.EXPIRED_TODO, daysLeft)
            } else {
                val daysLeft = currentDate.until(todoDate, DateTimeUnit.DAY)
                val fraction = index / todosCount.toFloat()
                val color = ColorEvaluator.evaluate(fraction, TodoColor.TODOS_START, TodoColor.TODOS_END)
                futureTodos += TodoListUiModel(todo, color, daysLeft)
            }
        }

        return Output(expiredTodos, futureTodos)
    }
}