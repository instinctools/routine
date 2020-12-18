package com.instinctools.routine_kmp.ui.widget

import android.content.Context
import android.graphics.Rect
import android.view.View
import androidx.annotation.DimenRes
import androidx.recyclerview.widget.RecyclerView

class VerticalSpacingDecoration(
    private val spacingPixelSize: Int
) : RecyclerView.ItemDecoration() {

    constructor(context: Context, @DimenRes spacingResId: Int) : this(context.resources.getDimensionPixelSize(spacingResId))

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        if (parent.getChildAdapterPosition(view) != parent.adapter?.itemCount ?: 0 - 1) {
            outRect.bottom = spacingPixelSize
        }
    }
}