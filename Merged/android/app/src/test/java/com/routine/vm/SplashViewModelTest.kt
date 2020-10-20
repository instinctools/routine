package com.routine.vm

import app.cash.turbine.test
import com.dropbox.android.external.store4.ResponseOrigin
import com.dropbox.android.external.store4.StoreResponse
import com.routine.test_utils.CommonRule
import junit.framework.TestCase.assertEquals
import kotlinx.coroutines.runBlocking
import org.junit.Before
import org.junit.Rule
import org.junit.Test

class SplashViewModelTest {

    private lateinit var splashViewModel: SplashViewModel

    @get:Rule
    var commonRule = CommonRule()

    @Before
    fun init() {
        splashViewModel = SplashViewModel(commonRule.todosRepository)
    }

    @Test
    fun login_success() = runBlocking {
        splashViewModel.login.cache
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Data(true, ResponseOrigin.Fetcher))
                cancelAndIgnoreRemainingEvents()
            }

    }

    @Test
    fun login_error() = runBlocking {
        val loginThrowable = Exception("Error login")
        commonRule.todosRepository.loginError = loginThrowable
        splashViewModel.login.cache
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Error.Exception(loginThrowable, ResponseOrigin.Fetcher))
                cancelAndIgnoreRemainingEvents()
            }
    }

    @Test
    fun login_errorRepeatSuccess() = runBlocking {
        val loginThrowable = Exception("Error login")
        commonRule.todosRepository.loginError = loginThrowable
        splashViewModel.login.cache
            .test {
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Error.Exception(loginThrowable, ResponseOrigin.Fetcher))
                commonRule.todosRepository.loginError = null
                splashViewModel.onRefreshClicked()
                assertEquals(expectItem(), StoreResponse.Loading(ResponseOrigin.Fetcher))
                assertEquals(expectItem(), StoreResponse.Data(true, ResponseOrigin.Fetcher))
                cancelAndIgnoreRemainingEvents()
            }
    }

    @Test
    fun login_errorRepeatError() = runBlocking {
        val loginThrowable = Exception("Error login")
        commonRule.todosRepository.loginError = loginThrowable
        splashViewModel.login.cache
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
