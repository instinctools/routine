import SwiftUI
import RoutineShared
import SwipeCell

struct TasksView: View {
    
    let addTaskAction: () -> Void
    let menuClickAction: () -> Void
    let itemClickAction: (_ taskId: String) -> Void
    let presenter: TodoListPresenter
    
    @State var state: TodoListPresenter.State
    
    @State var refreshErrorHappened: Bool = false
    @State var resetErrorHappened: Bool = false
    @State var deleteErrorHappened: Bool = false
    @State var successReset: Bool = false
    @State var successDelete: Bool = false
    
    @State var deleteConfirmation = DeleteConfirmation(isShown: false, taskId: nil)
    
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
                if(state.progress) {
                    ProgressView()
                        .padding()
                }
                ForEach(state.expiredTodos, id: \.todo.id) { task in
                    let leftSlot = resetButton(task: task)
                    let rightSlot = deleteButton(task: task)
                    TaskView(task: task)
                        .onTapGesture { itemClickAction(task.todo.id) }
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
                        .onTapGesture { itemClickAction(task.todo.id) }
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
            ToolbarItemGroup(placement: .primaryAction) {
                HStack {
                    Button(action: {
                        let action = TodoListPresenter.ActionRefresh()
                        presenter.sendAction(action: action)
                    }) { Image(systemName: "icloud.and.arrow.down") }
                    Button(action: addTaskAction) { Image(systemName: "plus") }
                }
            }
        }
        .alert(isPresented: $refreshErrorHappened, content: {
            Alert(title: Text("Error"), message: Text("Failed to refresh tasks"), dismissButton: .default(Text("Ok")))
        })
        .alert(isPresented: $resetErrorHappened, content: {
            Alert(title: Text("Error"), message: Text("Failed to reset task"), dismissButton: .default(Text("Ok")))
        })
        .alert(isPresented: $deleteErrorHappened, content: {
            Alert(title: Text("Error"), message: Text("Failed to delete task"), dismissButton: .default(Text("Ok")))
        })
        .alert(isPresented: $deleteConfirmation.isShown, content: {
            Alert(
                title: Text("Are you sure?"),
                message: Text("This action couldn't be undone"),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete"), action: {
                    if let taskId = deleteConfirmation.taskId {
                        let action = TodoListPresenter.ActionDeleteTask(taskId: taskId)
                        presenter.sendAction(action: action)
                    }
                })
            )
        })
        .snackBar(isShowing: $successReset, text: Text("Task renewed"))
        .snackBar(isShowing: $successDelete, text: Text("Task deleted"))
        
        .navigationBarTitle("Routine")
        .progressViewStyle(CircularProgressViewStyle())
        .attachPresenter(presenter: presenter, bindedState: $state)
        .onChange(of: state, perform: { value in
            self.refreshErrorHappened = state.refreshError.eventFired
            self.resetErrorHappened = state.resetError.eventFired
            self.deleteErrorHappened = state.deleteError.eventFired
            
            if value.resetDone.eventFired {
                self.successReset = true
            }
            if value.deleteDone.eventFired {
                self.successDelete = true
            }
        })
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
                self.deleteConfirmation.isShown = true
                self.deleteConfirmation.taskId = task.todo.id
            }
        )
        return SwipeCellSlot(slots: [resetButton])
    }
}

struct DeleteConfirmation {
    
    var isShown: Bool
    var taskId: String? = nil
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
