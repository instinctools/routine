package com.instinctools.routine_android

import android.content.Context
import android.content.Intent
import android.graphics.*
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.coroutineScope
import androidx.lifecycle.map
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.instinctools.routine_android.data.db.database
import com.instinctools.routine_android.data.model.Todo
import com.instinctools.routine_android.databinding.ActivityMainBinding
import com.instinctools.routine_android.databinding.ItemTodoBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
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

        database().todos()
            .getTodos()
            .map { list -> list.sortedBy { it.timestamp } }
            .map { Todo.from(it) }
            .observe(this, Observer {
                adapter.submitList(it)
            })
    }

    private class TodosAdapter : ListAdapter<Any, RecyclerView.ViewHolder>(object : DiffUtil.ItemCallback<Any>() {
        override fun areItemsTheSame(oldItem: Any, newItem: Any): Boolean {
            if (oldItem is Todo && newItem is Todo) {
                return oldItem.id == newItem.id
            }
            return true
        }

        override fun areContentsTheSame(oldItem: Any, newItem: Any): Boolean {
            if (oldItem is Todo && newItem is Todo) {
                return (oldItem as Todo) == (newItem as Todo)
            }
            return true
        }
    }) {

        companion object {
            const val TYPE_TODO = 0
            const val TYPE_SEPARATOR = 1
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
            return if (viewType == TYPE_TODO) {
                TodosViewHolder(ItemTodoBinding.inflate(LayoutInflater.from(parent.context), parent, false))
            } else {
                EmptyViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_separator, parent, false))
            }
        }

        override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
            val item = getItem(position)
            if (item is Todo) {
                (holder as TodosViewHolder).bind(item)
            }
        }

        override fun getItemViewType(position: Int): Int {
            val item = getItem(position)
            return if (item is Todo) {
                TYPE_TODO
            } else {
                TYPE_SEPARATOR
            }
        }
    }

    class TodosViewHolder(private val binding: ItemTodoBinding) : RecyclerView.ViewHolder(binding.root) {

        var todo: Todo? = null

        init {
            binding.root.setOnClickListener {
                todo?.let {
                    val intent = Intent(binding.root.context, DetailsActivity::class.java)
                    intent.putExtra("EXTRA_ID", it.id)
                    binding.root.context.startActivity(intent)
                }
            }
        }

        fun bind(todo: Todo) {
            this.todo = todo
            binding.title.text = todo.title
            binding.periodStr.text = todo.periodStr
            binding.targetDate.text = todo.targetDate

            val drawable = binding.root.background.mutate() as GradientDrawable
            drawable.setColor(todo.background)
        }
    }

    private class EmptyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)

    private inner class SwipeCallback(context: Context) : ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT or ItemTouchHelper.RIGHT) {

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

        var isLeftActivated = false
        var isRightActivated = false

        override fun onMove(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder, target: RecyclerView.ViewHolder): Boolean {
            return false
        }

        override fun getMovementFlags(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder): Int {
            return if (viewHolder is EmptyViewHolder) {
                makeMovementFlags(0, 0)
            } else {
                super.getMovementFlags(recyclerView, viewHolder)
            }
        }

        override fun clearView(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder) {
            super.clearView(recyclerView, viewHolder)
            if ((isLeftActivated || isRightActivated) && viewHolder is TodosViewHolder) {
                val todo = viewHolder.todo
                if (todo != null) {
                    if (isLeftActivated) {
                        lifecycle.coroutineScope.launch(Dispatchers.IO) {
                            val todoEntity = database().todos()
                                .getTodo(todo.id)

                            database().todos()
                                .updateTodo(
                                        todoEntity.copy(timestamp = calculateTimestamp(todoEntity.period, todoEntity.periodUnit))
                                )
                        }
                    } else if (isRightActivated) {
                        AlertDialog.Builder(this@MainActivity)
                            .setMessage("Are you sure want to delete this task?")
                            .setPositiveButton("DELETE") { dialog, which ->
                                lifecycle.coroutineScope.launch(Dispatchers.IO) {
                                    database().todos()
                                        .deleteTodo(todo.id)
                                }
                                dialog.dismiss()
                            }
                            .setNegativeButton("CANCEL") { dialog, which ->
                                dialog.dismiss()
                            }
                            .create()
                            .show()
                    }
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

            if (isCurrentlyActive) {
                if (abs(dX) > activateDistance) {
                    isLeftActivated = dX > 0
                    isRightActivated = dX < 0
                } else {
                    isLeftActivated = false
                    isRightActivated = false
                }
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
