package com.instinctools.routine_kmp.ui

import androidx.appcompat.app.AppCompatActivity
import com.instinctools.routine_kmp.domain.Store
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob

abstract class RetainPresenterActivity<ScreenPresenter : Store<*, *>> : AppCompatActivity() {

    protected val scope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())

    abstract var presenter: ScreenPresenter
    abstract val presenterCreator: () -> ScreenPresenter

    protected fun createPresenter() {
        presenter = lastCustomNonConfigurationInstance as? ScreenPresenter
            ?: presenterCreator().also { it.start() }
    }

    override fun onStop() {
        super.onStop()
        scope.cancelChildren()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (!isChangingConfigurations) {
            presenter.stop()
        }
    }

    override fun onRetainCustomNonConfigurationInstance() = presenter
}