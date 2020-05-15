import UIKit
import RoutineSharedKmp

class ViewController: UIViewController {

    var presenter: TodoListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.font = label.font.withSize(25)
        view.addSubview(label)

        let databaseProvider = IosDatabaseProvider()
        let todoStore = SqlDelightTodoStore(database: databaseProvider.database())
        presenter = TodoListPresenter(uiUpdater: { items in
            label.text = "Database have \(items.count) items"
        }, todoStore: todoStore)
        presenter.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter.stop()
    }
}

