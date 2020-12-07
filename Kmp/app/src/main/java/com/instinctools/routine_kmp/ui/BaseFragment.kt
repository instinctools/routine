package com.instinctools.routine_kmp.ui

import androidx.annotation.LayoutRes
import androidx.fragment.app.Fragment
import com.instinctools.routine_kmp.util.cancelChildren
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob

open class BaseFragment : Fragment {

    constructor() : super()
    constructor(@LayoutRes contentLayoutId: Int) : super(contentLayoutId)

    protected val viewScope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())

    override fun onDestroyView() {
        super.onDestroyView()
        viewScope.cancelChildren()
    }
}
