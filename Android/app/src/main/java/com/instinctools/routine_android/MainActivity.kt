package com.instinctools.routine_android

import android.content.Context
import android.content.Intent
import android.graphics.*
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_android.data.Todo
import com.instinctools.routine_android.databinding.ActivityMainBinding
import com.instinctools.routine_android.databinding.ItemTodoBinding
import kotlin.math.abs

class MainActivity : AppCompatActivity() {

    private val binding: ActivityMainBinding by viewBinding(ActivityMainBinding::inflate)
    private var adapter = TodosAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        binding.toolbar.setOnMenuItemClickListener {
            startActivity(Intent(this, DetailsActivity::class.java))
            true
        }

        binding.content.adapter = adapter
        ItemTouchHelper(SwipeCallback(this)).attachToRecyclerView(binding.content)

        val list = mutableListOf<Todo>()
        for (i in 0..50) {
            list.add(Todo(i))
        }

        adapter.submitList(list)
    }

    private class TodosAdapter : ListAdapter<Todo, TodosViewHolder>(object : DiffUtil.ItemCallback<Todo>() {
        override fun areItemsTheSame(oldItem: Todo, newItem: Todo): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: Todo, newItem: Todo): Boolean {
            return oldItem == newItem
        }
    }) {
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TodosViewHolder {
            return TodosViewHolder(ItemTodoBinding.inflate(LayoutInflater.from(parent.context), parent, false))
        }

        override fun onBindViewHolder(holder: TodosViewHolder, position: Int) {
            holder.bind(getItem(position))
        }
    }

    private class TodosViewHolder(val binding: ItemTodoBinding) : RecyclerView.ViewHolder(binding.root) {

        fun bind(todo: Todo) {
            binding.title.text = todo.title
            binding.periodStr.text = todo.periodStr
            binding.periodDate.text = todo.periodDate

            val drawable = binding.root.background.mutate() as GradientDrawable
            drawable.setColor(Color.GREEN)
        }
    }

    private class SwipeCallback(context: Context) : ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT or ItemTouchHelper.RIGHT) {

        val btnPaint = Paint()
        val btnColor = Color.parseColor("#E3E3E3")
        val btnColorActivated = Color.parseColor("#b2b2b2")

        var textRect = Rect()
        var btnRect = RectF()

        val textPaint = Paint()
            .apply {
                isAntiAlias = true
                color = Color.WHITE
                textSize = context.resources.getDimension(R.dimen.swipeable_text)
            }

        val buttonWidth = context.resources.getDimensionPixelOffset(R.dimen.swipeable_btn_width)
        val activateDistance = context.resources.getDimensionPixelOffset(R.dimen.swipeable_activate_distance)
        val corners = context.resources.getDimension(R.dimen.todo_item_corner)

        override fun onMove(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder, target: RecyclerView.ViewHolder): Boolean {
            return false
        }

        override fun onSelectedChanged(viewHolder: RecyclerView.ViewHolder?, actionState: Int) {
            super.onSelectedChanged(viewHolder, actionState)

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
            c: Canvas, recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder,
            dX: Float, dY: Float, actionState: Int, isCurrentlyActive: Boolean
        ) {
            super.onChildDraw(c, recyclerView, viewHolder, dX, dY, actionState, isCurrentlyActive)

            val text: String
            val x: Float
            if (dX > 0) {
                x = dX - buttonWidth
                text = "Reset"
            } else {
                x = dX + recyclerView.width
                text = "Delete"
            }

            if (abs(dX) > activateDistance) {
                btnPaint.color = btnColorActivated
            } else {
                btnPaint.color = btnColor
            }

            c.save()
            c.translate(x, viewHolder.itemView.top.toFloat())
            textPaint.getTextBounds(text, 0, text.length, textRect)
            btnRect.set(0f, 0f, buttonWidth.toFloat(), viewHolder.itemView.height.toFloat())
            c.drawRoundRect(btnRect, corners, corners, btnPaint)
            c.drawText(text, btnRect.centerX() - (textRect.width() / 2), btnRect.centerY() + textRect.height() / 2, textPaint)
            c.restore()
        }
    }
}
