import SwiftUI
import Firebase

@main
struct RoutineApp: App {
    
    let injector = Injector()
    
    @State var loggedIn: Bool = false
    
    init() {
        print("asd_asd: app initialized")
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let _ = print("asd_asd: view recreated")
                if (loggedIn) {
                    TasksView(
                        presenter: injector.makeTodoListPresenter(),
                        addTaskAction: { print("Add item clicked")},
                        menuClickAction: { print("Menu clicked") },
                        itemClickAction: { taskId in print("Task clicked, id=\(taskId)") }
                    )
                } else {
                    SplashView(
                        presenter: injector.makeSplashPresenter(),
                        loginAction: {
                            print("Logged in!")
                            self.loggedIn = true
                        }
                    )
                }
            }
        }
    }

}
