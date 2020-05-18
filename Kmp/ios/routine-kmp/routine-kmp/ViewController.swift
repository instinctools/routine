import UIKit
import RoutineSharedKmp

class ViewController: UIViewController {

    var presenter: TodoListPresenter!
    let uiBinder = UiBinder<TodoListPresenter.State, TodoListPresenter.Event>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.font = label.font.withSize(25)
        view.addSubview(label)

        let databaseProvider = IosDatabaseProvider()
        let todoStore = SqlDelightTodoStore(database: databaseProvider.database())
        presenter = TodoListPresenter(todoStore: todoStore)
        
        uiBinder.bindTo(presenter: presenter, listener: { state, oldState in
            label.text = "Database have \(state.items.count) items"
        })
        
        presenter.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter.stop()
        uiBinder.destroy()
    }
    
}

