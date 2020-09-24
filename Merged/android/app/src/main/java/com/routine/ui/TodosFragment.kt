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
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.*
import com.dropbox.android.external.store4.StoreResponse
import com.routine.R
import com.routine.common.home.vm.HomeViewModel
import com.routine.common.launchIn
import com.routine.common.showError
import com.routine.common.throttleFirst
import com.routine.common.viewBinding
import com.routine.data.model.Event
import com.routine.data.model.TodoListItem
import com.routine.databinding.FragmentTodosBinding
import com.routine.databinding.ItemTodoBinding
import com.routine.vm.AndroidAppViewModel
import dev.chrisbanes.insetter.Insetter
import dev.chrisbanes.insetter.Side
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
class TodosFragment : Fragment(R.layout.fragment_todos) {

    private val homeViewModel by activityViewModels<HomeViewModel>()
    private val viewModel by viewModels<AndroidAppViewModel>()
    private val binding by viewBinding(FragmentTodosBinding::bind)
    private var adapter: TodosAdapter? = null
    private val swipeCallback by lazy { SwipeCallback(requireActivity()) }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        Insetter.builder()
            .applySystemWindowInsetsToPadding(Side.BOTTOM)
            .applyToView(binding.content)

        Insetter.builder()
            .applySystemGestureInsetsToMargin(Side.BOTTOM)
            .applyToView(binding.messageAnchor)

        adapter = TodosAdapter(viewLifecycleOwner.lifecycleScope)

        binding.toolbar.setNavigationOnClickListener {
            homeViewModel.onMenuClicked()
        }

        binding.toolbar.setOnMenuItemClickListener {
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
                adapter?.submitList(it.value)
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        viewModel.todosStatus
            .sample(400)
            .onEach { data: StoreResponse<List<Any>> ->
                when (data) {
                    is StoreResponse.Loading -> adjustVisibility(true)
                    is StoreResponse.Data -> adjustVisibility(false)
                    is StoreResponse.Error.Exception -> {
                        binding.progress.visibility = View.GONE
                        binding.messageAnchor.showError { viewModel.refresh() }
                    }
                }
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        binding.refresh.setOnRefreshListener {
            viewModel.refresh()
        }

        viewModel.actionTodo
            .onEach {
                if (it is StoreResponse.Error.Exception){
                    binding.messageAnchor.showError()
                }
                swipeCallback.isEnabled = it !is StoreResponse.Loading
                binding.progress.visibility = if (it !is StoreResponse.Loading) View.GONE else View.VISIBLE
            }
            .launchIn(viewLifecycleOwner.lifecycleScope)

        adapter?.clicksFlow?.onEach {
            it?.getContentIfNotHandled()?.let {
                findNavController().navigate(TodosFragmentDirections.actionTodosDetails(it.id))
            }
        }?.launchIn(lifecycleScope)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        adapter = null
    }

    private fun adjustVisibility(isProgress: Boolean) {
        binding.progress.visibility = if (isProgress && adapter?.itemCount == 0) View.VISIBLE else View.GONE
        binding.content.visibility = if (isProgress && adapter?.itemCount == 0) View.GONE else View.VISIBLE
        binding.placeHolderGroup.visibility = if (adapter?.itemCount == 0) View.VISIBLE else View.GONE
        binding.refresh.isRefreshing = isProgress && (adapter?.let { it.itemCount > 0 } == true)

        swipeCallback.isEnabled = !isProgress
    }

    private class TodosAdapter(val coroutineScope: CoroutineScope) : ListAdapter<TodoListItem, RecyclerView.ViewHolder>(object : DiffUtil.ItemCallback<TodoListItem>() {

        override fun areItemsTheSame(oldItem: TodoListItem, newItem: TodoListItem): Boolean {
            return ((oldItem is TodoListItem.Todo && newItem is TodoListItem.Todo && (oldItem.id == newItem.id)) ||
                    (oldItem is TodoListItem.Separator && newItem is TodoListItem.Separator))
        }

        override fun areContentsTheSame(oldItem: TodoListItem, newItem: TodoListItem): Boolean {
            if (oldItem is TodoListItem.Todo && newItem is TodoListItem.Todo) {
                return oldItem == newItem
            }
            return true
        }
    }) {

        val clicksFlow = MutableStateFlow<Event<TodoListItem.Todo>?>(null)

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
            if (item is TodoListItem.Todo && holder is TodosViewHolder) {
                holder.bind(item)
            }
        }

        override fun getItemViewType(position: Int): Int =
            when (getItem(position)) {
                is TodoListItem.Todo -> TYPE_TODO
                is TodoListItem.Separator -> TYPE_SEPARATOR
            }
    }

    class TodosViewHolder(private val binding: ItemTodoBinding) : RecyclerView.ViewHolder(binding.root) {

        var todo: TodoListItem.Todo? = null

        fun bind(todo: TodoListItem.Todo) {
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
                        viewModel.resetTodo(todo)
                    } else if (isRightActivated) {
                        AlertDialog.Builder(requireActivity())
                            .setMessage("Are you sure want to delete this task?")
                            .setPositiveButton("DELETE") { dialog, which ->
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
