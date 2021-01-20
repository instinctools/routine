import SwiftUI
import RoutineShared

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
        List {
            ForEach(state.expiredTodos, id: \.todo.id) { task in
                TaskView(task: task)
            }
            if(!state.expiredTodos.isEmpty) {
                Divider()
            }
            ForEach(state.futureTodos, id: \.todo.id) { task in
                TaskView(task: task)
            }
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
