import SwiftUI
import RoutineShared
import SwipeCell

struct TasksView: View {
    
    let addTaskAction: () -> Void
    let menuClickAction: () -> Void
    let itemClickAction: (_ taskId: String) -> Void
    let presenter: TodoListPresenter
    @State var state: TodoListPresenter.State
    
    init(
        presenter: TodoListPresenter,
        addTaskAction: @escaping () -> Void,
        menuClickAction: @escaping () -> Void,
        itemClickAction: @escaping (_ taskId: String) -> Void
    ) {
        self.presenter = presenter
        self.addTaskAction = addTaskAction
        self.menuClickAction = menuClickAction
        self.itemClickAction = itemClickAction
        let value = presenter.states.value as! TodoListPresenter.State
        _state = State<TodoListPresenter.State>.init(initialValue: value)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(state.expiredTodos, id: \.todo.id) { task in
                    let leftSlot = resetButton(task: task)
                    let rightSlot = deleteButton(task: task)
                    TaskView(task: task)
                        .swipeCell(cellPosition: .both, leftSlot: leftSlot, rightSlot: rightSlot)
                        .dismissSwipeCellForScrollViewForLazyVStack()
                }
                
                if(!state.expiredTodos.isEmpty) {
                    Divider()
                }
                ForEach(state.futureTodos, id: \.todo.id) { task in
                    let leftSlot = resetButton(task: task)
                    let rightSlot = deleteButton(task: task)
                    TaskView(task: task)
                        .swipeCell(cellPosition: .both, leftSlot: leftSlot, rightSlot: rightSlot)
                        .dismissSwipeCellForScrollViewForLazyVStack()
                }
            }
            .padding(.horizontal, 16)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: menuClickAction) { Image("Side Menu") }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: addTaskAction) { Image(systemName: "plus") }
            }
        }
        .navigationBarTitle("Routine")
        .attachPresenter(presenter: presenter, bindedState: $state)
    }
    
    func resetButton(task: TodoListUiModel) -> SwipeCellSlot {
        let resetButton = SwipeCellButton(
            buttonStyle: .title,
            title: "Reset",
            systemImage: nil,
            view: nil,
            backgroundColor: Color(red: 0.698, green:0.698, blue: 0.698),
            action: {
                let action = TodoListPresenter.ActionResetTask(taskId: task.todo.id)
                presenter.sendAction(action: action)
            }
        )
        return SwipeCellSlot(slots: [resetButton])
    }
    
    func deleteButton(task: TodoListUiModel) -> SwipeCellSlot {
        let resetButton = SwipeCellButton(
            buttonStyle: .title,
            title: "Delete",
            systemImage: nil,
            view: nil,
            backgroundColor: Color(red: 0.698, green:0.698, blue: 0.698),
            action: {
                let action = TodoListPresenter.ActionDeleteTask(taskId: task.todo.id)
                presenter.sendAction(action: action)
            }
        )
        return SwipeCellSlot(slots: [resetButton])
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = Injector().makeTodoListPresenter()
        TasksView(
            presenter: presenter,
            addTaskAction: {},
            menuClickAction: {},
            itemClickAction: {_ in }
        )
    }
}
