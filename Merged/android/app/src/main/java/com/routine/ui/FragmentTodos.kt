package com.routine.ui

import android.content.Context
import android.graphics.*
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.*
import com.dropbox.android.external.store4.StoreResponse
import com.google.android.material.snackbar.Snackbar
import com.routine.R
import com.routine.common.*
import com.routine.common.home.vm.HomeViewModel
import com.routine.data.model.Event
import com.routine.data.model.Todo
import com.routine.databinding.FragmentTodosBinding
import com.routine.databinding.ItemTodoBinding
import com.routine.vm.AndroidAppViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.*
import reactivecircus.flowbinding.android.view.clicks
import timber.log.Timber
import kotlin.math.abs

@ExperimentalStdlibApi
@FlowPreview
@ExperimentalCoroutinesApi
class FragmentTodos : Fragment(R.layout.fragment_todos) {

    private val homeViewModel by activityViewModels<HomeViewModel>()
    private val viewModel by viewModels<AndroidAppViewModel>()
    private val binding by viewBinding(FragmentTodosBinding::bind)
    private val adapter = TodosAdapter(lifecycleScope)
    private val swipeCallback by lazy { SwipeCallback(requireActivity()) }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.toolbar.setNavigationOnClickListener {
            homeViewModel.onMenuClicked()
        }

        binding.toolbar.setOnMenuItemClickListener {
            Analytics.action("add_todo_android")
            findNavController().navigate(R.id.action_todos_details)
            true
        }

        ItemTouchHelper(swipeCallback).attachToRecyclerView(binding.content)
        val animator = binding.content.itemAnimator
        if (animator is SimpleItemAnimator) {
            animator.supportsChangeAnimations = false
        }

        binding.content.adapter = adapter

        viewModel.todosData
            .onEach {
                adapter.submitList(it.dataOrNull())
            }
            .launchIn(lifecycleScope)

        viewModel.todosStatus
            .sample(400)
            .onEach { data: StoreResponse<List<Any>> ->
                Timber.i("Response, ${data::class} from: ${data.origin}, data: ${data.dataOrNull()}")
                when (data) {
                    is StoreResponse.Loading -> adjustVisibility(true)
                    is StoreResponse.Data -> adjustVisibility(false)
                    is StoreResponse.Error.Exception -> {
                        binding.progress.visibility = View.GONE
                        showError(
                            binding.root,
                            data.error
                        ) {
                            viewModel.refresh()
                        }
                    }
                }
            }
            .launchIn(lifecycleScope)

        binding.refresh.setOnRefreshListener {
            viewModel.refresh()
        }

        viewModel.actionTodo
            .observe(requireActivity(), Observer {
                when (it) {
                    is StoreResponse.Error.Exception -> {
                        Snackbar.make(binding.root, it.error.getErrorMessage(), Snackbar.LENGTH_SHORT).show()
                    }
                }
                swipeCallback.isEnabled = it !is StoreResponse.Loading
                binding.progress.visibility = if (it !is StoreResponse.Loading) View.GONE else View.VISIBLE
            })

        adapter.clicksFlow
            .onEach {
                it?.getContentIfNotHandled()?.let {
                    findNavController().navigate(FragmentTodosDirections.actionTodosDetails(it.id))
                }
            }
            .launchIn(lifecycleScope)
    }

    private fun adjustVisibility(isProgress: Boolean) {
        binding.progress.visibility = if (isProgress && adapter.itemCount == 0) View.VISIBLE else View.GONE
        binding.content.visibility = if (isProgress && adapter.itemCount == 0) View.GONE else View.VISIBLE
        binding.placeHolderGroup.visibility = if (adapter.itemCount == 0) View.VISIBLE else View.GONE
        binding.refresh.isRefreshing = isProgress && adapter.itemCount > 0
        swipeCallback.isEnabled = !isProgress
    }

    private class TodosAdapter(val coroutineScope: CoroutineScope) : ListAdapter<Any, RecyclerView.ViewHolder>(object : DiffUtil.ItemCallback<Any>() {

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

        val clicksFlow = MutableStateFlow<Event<Todo>?>(null)

        companion object {
            const val TYPE_TODO = 0
            const val TYPE_SEPARATOR = 1
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
            return if (viewType == TYPE_TODO) {
                TodosViewHolder(
                    ItemTodoBinding.inflate(LayoutInflater.from(parent.context), parent, false)
                ).apply {
                    clicks().launchIn(coroutineScope, clicksFlow)
                }
            } else {
                EmptyViewHolder(
                    LayoutInflater.from(parent.context).inflate(
                        R.layout.item_separator,
                        parent,
                        false
                    )
                )
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

        fun bind(todo: Todo) {
            this.todo = todo
            binding.title.text = todo.title
            binding.periodStr.text = todo.periodStr
            binding.targetDate.text = todo.targetDate

            val drawable = binding.root.background.mutate() as GradientDrawable
            drawable.setColor(todo.background)
        }

        fun clicks() =
            binding.root
                .clicks()
                .throttleFirst(500)
                .map { todo }
                .filter { it != null }
                .map { it!! }
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
        var isEnabled = true

        override fun onMove(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder, target: RecyclerView.ViewHolder): Boolean {
            return false
        }

        override fun getMovementFlags(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder): Int {
            return if (!isEnabled || viewHolder is EmptyViewHolder) {
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
                        Analytics.action("reset_todo_android")
                        viewModel.resetTodo(todo)
                    } else if (isRightActivated) {
                        AlertDialog.Builder(requireActivity())
                            .setMessage("Are you sure want to delete this task?")
                            .setPositiveButton("DELETE") { dialog, which ->
                                Analytics.action("delete_todo_android")
                                viewModel.removeTodo(todo)
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
