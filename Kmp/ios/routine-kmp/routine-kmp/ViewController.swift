import UIKit
import RoutineSharedKmp

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.font = label.font.withSize(25)
        view.addSubview(label)

        let databaseProvider = IosDatabaseProvider()
        let todoStore = SqlDelightTodoStore(database: databaseProvider.database())
        
        for item in 0...10 {
            todoStore.insert(todo: Todo(id: 0, title: "Todo \(item)", periodType: PeriodType.daily, periodValue: 1, nextTimestamp: 0))
        }
        
        let todos = todoStore.getTodos()
        
        label.text = String(todos.count)
    }
}

