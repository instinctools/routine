import UIKit
import Firebase
import RoutineShared

class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: DI
    lazy var database = IosDatabaseProvider().database()
    lazy var todoStore = SqlTodoStore(database: database)
    lazy var firebaseTodoStore = FirebaseTodoStore(interactor: FirestoreInteractor())
    
    lazy var authRepository = AuthRepository(firebaseAuthenticator: FirebaseAuthenticator(interactor: FirebaseAuthInteractor()))
    lazy var todoRepository = TodoRepository(
        firebaseTodoStore: firebaseTodoStore,
        localTodoStore: todoStore,
        authRepository: authRepository
    )
    
    lazy var ensureLoginSideEffect = EnsureLoginSideEffect(authRepository: authRepository)
    
    lazy var getTasksSideEffect = GetTasksSideEffect(todoRepository: todoRepository)
    lazy var deleteTaskSideEffect = DeleteTaskSideEffect(todoRepository: todoRepository)
    lazy var resetTaskSideEffect = ResetTaskSideEffect(todoRepository: todoRepository)
    lazy var refreshTasksSideEffect = RefreshTasksSideEffect(todoRepository: todoRepository)
    
    lazy var getTaskByIdSideEffect = GetTaskByIdSideEffect(todoRepository: todoRepository)
    lazy var saveTaskSideEffect = SaveTaskSideEffect(todoRepository: todoRepository)
    
    // MARK: App
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
