import SwiftUI
import Firebase
import NavigationStack
import RoutineShared

@main
struct RoutineApp: App {
    
    let injector = Injector()
    @ObservedObject var router: Router
    
    init() {
        FirebaseApp.configure()
        self.router = Router(injector: injector)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if let (destination, presenter) = router.currentState {
                    switch destination {
                    case .splash:
                        SplashView(
                            presenter: presenter as! SplashPresenter,
                            loginAction: {
                                self.router.root(destination: .tasks)
                            }
                        )
                    case .tasks:
                        TasksView(
                            presenter: presenter as! TodoListPresenter,
                            addTaskAction: {
                                self.router.push(destination: .taskDetails())
                            },
                            menuClickAction: { print("Menu clicked") },
                            itemClickAction: { taskId in
                                print("item clicked \(taskId)")
                                self.router.push(destination: .taskDetails(todoId: taskId))
                            }
                        )
                    case .taskDetails:
                        TaskDetailsView(
                            presenter: presenter as! TodoDetailsPresenter,
                            cancelAction: { router.pop() },
                            savedAction: { router.pop() }
                        )
                    }
                    
                } else {
                    EmptyView()
                }
            }
        }
    }
}
