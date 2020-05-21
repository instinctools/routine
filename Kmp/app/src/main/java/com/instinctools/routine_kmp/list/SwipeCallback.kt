package com.instinctools.routine_kmp.list

import android.content.Context
import android.graphics.*
import androidx.core.graphics.withTranslation
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_kmp.R
import com.instinctools.routine_kmp.list.adapter.EmptyViewHolder
import com.instinctools.routine_kmp.list.adapter.TodosViewHolder
import kotlin.math.abs

class SwipeCallback(
    context: Context,
    private val callback: SwipeActionsCallback
) : ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT or ItemTouchHelper.RIGHT) {

    private val btnPaint = Paint()
    private val btnColor = Color.parseColor("#E3E3E3")
    private val btnColorActivated = Color.parseColor("#b2b2b2")

    private var textRect = Rect()
    private var btnRect = RectF()

    private val textPaint = Paint().apply {
        isAntiAlias = true
        color = Color.WHITE
        textSize = context.resources.getDimension(R.dimen.swipeable_text)
    }

    private val buttonWidth = context.resources.getDimensionPixelOffset(R.dimen.swipeable_btn_width)
    private val activateDistance = context.resources.getDimensionPixelOffset(R.dimen.swipeable_activate_distance)
    private val corners = context.resources.getDimension(R.dimen.todo_item_corner)

    var isLeftActivated = false
    var isRightActivated = false

    override fun onMove(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder, target: RecyclerView.ViewHolder): Boolean {
        return false
    }

    override fun getMovementFlags(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder): Int {
        return if (viewHolder is EmptyViewHolder) {
            makeMovementFlags(0, 0)˚
        } else {
            super.getMovementFlags(recyclerView, viewHolder)
        }
    }

    override fun clearView(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder) {
        super.clearView(recyclerView, viewHolder)
        if ((isLeftActivated || isRightActivated) && viewHolder is TodosViewHolder) {
            val item = viewHolder.item ?: return
            if (isLeftActivated) {
                callback.onLeftActivated(item)
            } else if (isRightActivated) {
                callback.onRightActivated(item)
            }
        }
        isLeftActivated = false
        isRightActivated = false
    }

    override fun onSwiped(viewHolder: RecyclerView.ViewHolder, direction: Int) {
    }

    override fun getSwipeThreshold(viewHolder: RecyclerView.ViewHolder): Float {
        return 2f
    }

    override fun getSwipeVelocityThreshold(defaultValue: Float): Float {
        return 0f
    }

    override fun onChildDraw(
        canvas: Canvas,
        recyclerView: RecyclerView,
        viewHolder: RecyclerView.ViewHolder,
        dX: Float,
        dY: Float,
        actionState: Int,
        isCurrentlyActive: Boolean
    ) {
        super.onChildDraw(canvas, recyclerView, viewHolder, dX, dY, actionState, isCurrentlyActive)

        val text: String
        val x: Float
        if (dX > 0) {
            x = dX - buttonWidth
            text = "Reset"
        } else {
            x = dX + recyclerView.width
            text = "Delete"
        }

        btnPaint.color = if (abs(dX) > activateDistance) btnColorActivated else btnColor

        if (isCurrentlyActive) {
            if (abs(dX) > activateDistance) {
                isLeftActivated = dX > 0
                isRightActivated = dX < 0
            } else {
                isLeftActivated = false
                isRightActivated = false
            }
        }

        canvas.withTranslation(x, viewHolder.itemView.top.toFloat()) {
            textPaint.getTextBounds(text, 0, text.length, textRect)
            btnRect.set(0f, 0f, buttonWidth.toFloat(), viewHolder.itemView.height.toFloat())
            canvas.drawRoundRect(btnRect, corners, corners, btnPaint)
            canvas.drawText(text, btnRect.centerX() - (textRect.width() / 2), btnRect.centerY() + textRect.height() / 2, textPaint)
        }
    }
}