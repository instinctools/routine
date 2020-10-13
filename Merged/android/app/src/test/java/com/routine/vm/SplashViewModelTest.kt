package com.routine.vm

import app.cash.turbine.test
import com.dropbox.android.external.store4.ResponseOrigin
import com.dropbox.android.external.store4.StoreResponse
import com.routine.data.repo.FakeTodosRepository
import junit.framework.TestCase.assertEquals
import kotlinx.coroutines.*
import kotlinx.coroutines.test.*
import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.time.ExperimentalTime

class SplashViewModelTest {

    private lateinit var todosRepository: FakeTodosRepository
    private lateinit var splashViewModel: SplashViewModel

    private val testDispatcher = TestCoroutineDispatcher()

    @Before
    fun init() {
        Dispatchers.setMain(testDispatcher)
        todosRepository = FakeTodosRepository()
        splashViewModel = SplashViewModel(todosRepository)
    }

    @After
    fun reset() {
        Dispatchers.resetMain()
        testDispatcher.cleanupTestCoroutines()
    }


    @Test
    fun login_success() = runBlocking {
        splashViewModel.login
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Data(true, ResponseOrigin.Fetcher))
                cancelAndIgnoreRemainingEvents()
            }

    }

    @Test
    fun login_error() = runBlocking {
        val loginThrowable = Exception("Error login")
        todosRepository.loginError = loginThrowable
        splashViewModel.login
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Error.Exception(loginThrowable, ResponseOrigin.Fetcher))
                cancelAndIgnoreRemainingEvents()
            }
    }

    @Test
    fun login_errorRepeatSuccess() = runBlocking {
        val loginThrowable = Exception("Error login")
        todosRepository.loginError = loginThrowable
        splashViewModel.login
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Error.Exception(loginThrowable, ResponseOrigin.Fetcher))
                todosRepository.loginError = null
                splashViewModel.onRefreshClicked()
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Data(true, ResponseOrigin.Fetcher))
                cancelAndIgnoreRemainingEvents()
            }
    }

    @Test
    fun login_errorRepeatError() = runBlocking {
        val loginThrowable = Exception("Error login")
        todosRepository.loginError = loginThrowable
        splashViewModel.login
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Error.Exception(loginThrowable, ResponseOrigin.Fetcher))
                splashViewModel.onRefreshClicked()
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Error.Exception(loginThrowable, ResponseOrigin.Fetcher))
                cancelAndIgnoreRemainingEvents()
            }
    }
}
