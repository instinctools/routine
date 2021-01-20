import RoutineShared

class Injector {
    
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
    
    init() {
        print("asd_asd: injector recreated")
    }
    
    func makeSplashPresenter() -> SplashPresenter {
        return SplashPresenter(ensureLoginSideEffect: ensureLoginSideEffect)
    }
    
    func makeTodoListPresenter() -> TodoListPresenter {
        return TodoListPresenter(
            getTasksSideEffect: getTasksSideEffect,
            deleteTaskSideEffect: deleteTaskSideEffect,
            resetTaskSideEffect: resetTaskSideEffect,
            refreshTasksSideEffect: refreshTasksSideEffect
        )
    }
    
    func makeTodoDetailsPresenter(todoId: String?) -> TodoDetailsPresenter {
        return TodoDetailsPresenter(todoId: todoId, getTaskByIdSideEffect: getTaskByIdSideEffect, saveTaskSideEffect: saveTaskSideEffect)
    }
}
