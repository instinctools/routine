import SwiftUI

class Router: ObservableObject {
    
    private var backStack: [Destination] = []
    private var presenters: [AnyObject] = []
    private var injector: Injector
    
    @Published var currentState: (Destination, AnyObject)? = nil
    
    init(injector: Injector, startDestination: Destination = .splash) {
        self.injector = injector
        push(destination: startDestination)
    }
    
    func push(destination: Destination) {
        backStack.append(destination)
        presenters.append(createPresenter(destination: destination))
        self.syncState()
    }
    
    func root(destination: Destination) {
        backStack.removeAll()
        presenters.removeAll()

        backStack.append(destination)
        presenters.append(createPresenter(destination: destination))
        self.syncState()
    }
    
    func pop() {
        backStack.removeLast()
        presenters.removeLast()
        self.syncState()
    }
    
    private func syncState() {
        let destination = backStack.last!
        let presenter = presenters.last!
        currentState = (destination, presenter)
    }
    
    private func createPresenter(destination: Destination) -> AnyObject {
        switch destination {
        case .splash: return injector.makeSplashPresenter()
        case .tasks: return injector.makeTodoListPresenter()
        case .taskDetails(let todoId): return injector.makeTodoDetailsPresenter(todoId: todoId)
        }
    }
}

enum Destination {
    case splash
    case tasks
    case taskDetails(todoId: String? = nil)
}
