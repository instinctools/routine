package com.routine.common

import androidx.fragment.app.Fragment
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.observe
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty

private class LifecycledLazyDelegate<T>(
    val fragment: Fragment,
    val factory: () -> T,
    val detachCallback: ((view: T) -> Unit)? = null
) : ReadOnlyProperty<Fragment, T> {
    private var _binding: T? = null

    init {
        fragment.lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onCreate(owner: LifecycleOwner) {
                fragment.viewLifecycleOwnerLiveData.observe(fragment) { viewLifecycleOwner ->
                    viewLifecycleOwner.lifecycle.addObserver(object : DefaultLifecycleObserver {
                        override fun onDestroy(owner: LifecycleOwner) {
                            _binding?.let {
                                detachCallback?.invoke(it)
                            }
                            _binding = null
                        }
                    })
                }
            }
        })
    }

    override fun getValue(thisRef: Fragment, property: KProperty<*>): T {
        val binding = _binding
        if (binding != null) {
            return binding
        }

        val lifecycle = fragment.viewLifecycleOwner.lifecycle
        if (!lifecycle.currentState.isAtLeast(Lifecycle.State.INITIALIZED)) {
            throw IllegalStateException("Should not attempt to this lazy delegate when Fragment views are destroyed.")
        }

        return factory().also { _binding = it }
    }
}

fun <T> Fragment.lazyOnViewLifecycle(factory: () -> T, detachCallback: ((view: T) -> Unit)? = null): ReadOnlyProperty<Fragment, T> = LifecycledLazyDelegate(this, factory, detachCallback)
