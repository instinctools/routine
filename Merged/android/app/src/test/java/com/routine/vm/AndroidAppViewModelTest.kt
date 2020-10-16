package com.routine.vm

import androidx.test.ext.junit.runners.AndroidJUnit4
import app.cash.turbine.test
import com.dropbox.android.external.store4.ResponseOrigin
import com.dropbox.android.external.store4.StoreResponse
import com.routine.common.calculateTimestamp
import com.routine.data.db.entity.PeriodUnit
import com.routine.data.db.entity.ResetType
import com.routine.data.db.entity.TodoEntity
import com.routine.data.model.TodoListItem
import com.routine.test_utils.CommonRule
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class AndroidAppViewModelTest {

    @get:Rule
    var commonRule = CommonRule()

    private lateinit var androidAppViewModel: AndroidAppViewModel

    @Before
    fun init() {
        androidAppViewModel = AndroidAppViewModel(commonRule.todosRepository)
    }


    @Test
    fun loadTodos_Success() = runBlocking {
        val todoEntities = getTestTodoEntities()
        val todoItems = TodoListItem.from(todoEntities)
        commonRule.todosRepository.todosStoreData = todoEntities
        androidAppViewModel.todosData
            .test {
                assertEquals(expectItem(), StoreResponse.Data(todoItems, ResponseOrigin.Fetcher))
                cancelAndIgnoreRemainingEvents()
            }
    }

    @Test
    fun loadTodos_SuccessStatus() = runBlocking {
        val todoEntities = getTestTodoEntities()
        commonRule.todosRepository.todosStoreData = todoEntities
        androidAppViewModel.todosStatus
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertTrue(expectItem() is StoreResponse.Data)
            }
    }

    @Test
    fun loadTodos_Error() = runBlocking {
        val exception = Exception("Error")
        commonRule.todosRepository.todosStoreError = exception
        androidAppViewModel.todosData
            .test {
                expectNoEvents()
            }
    }

    @Test
    fun loadTodos_ErrorStatus() = runBlocking {
        val exception = Exception("Error")
        commonRule.todosRepository.todosStoreError = exception
        androidAppViewModel.todosStatus
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Error.Exception(exception, ResponseOrigin.Fetcher))
            }
    }

    private fun getTestTodoEntities() = mutableListOf(
            TodoEntity(
                    "b5f36d25-1ee6-4a66-85c7-284262511b6e",
                    "TODO_1",
                    1,
                    PeriodUnit.DAY,
                    calculateTimestamp(1, PeriodUnit.DAY, ResetType.BY_DATE),
                    ResetType.BY_DATE),

            TodoEntity(
                    "f64d3fd6-97aa-4f34-be1b-9801688fb09c",
                    "TODO_2",
                    1,
                    PeriodUnit.MONTH,
                    calculateTimestamp(1, PeriodUnit.MONTH, ResetType.BY_PERIOD),
                    ResetType.BY_PERIOD),

            TodoEntity(
                    "1dc500a3-b876-44e6-ad4e-e39c17b49073",
                    "TODO_3",
                    1,
                    PeriodUnit.MONTH,
                    calculateTimestamp(1, PeriodUnit.MONTH, ResetType.BY_DATE),
                    ResetType.BY_DATE),

            TodoEntity(
                    "174ef365-f440-4de3-bda6-4b24e7296099",
                    "TODO_4",
                    1,
                    PeriodUnit.WEEK,
                    calculateTimestamp(1, PeriodUnit.WEEK, ResetType.BY_PERIOD),
                    ResetType.BY_PERIOD),

            TodoEntity(
                    "1e0f6e95-bee2-4d89-adb8-1914fc2aeb8b",
                    "TODO_5",
                    1,
                    PeriodUnit.DAY,
                    calculateTimestamp(1, PeriodUnit.DAY, ResetType.BY_PERIOD),
                    ResetType.BY_PERIOD),

            TodoEntity(
                    "a1a09c4c-8c8f-467e-a12e-90f6f4211158",
                    "TODO_6",
                    1,
                    PeriodUnit.DAY,
                    calculateTimestamp(1, PeriodUnit.DAY, ResetType.BY_PERIOD),
                    ResetType.BY_PERIOD)
    )
}
