//
//  Factory.swift
//  Factory
//
//  Created by Vadim Koronchik on 30.07.21.
//

import Foundation

class Factory: FactoryProtocol {
    
    private lazy var taskProvider = CoreDataTaskProvider(
        managedObjectContext: CoreDataStack.shared.mainContext
    )

    func makeTaskListViewModel() -> TaskListViewModel {
        return TaskListViewModel(taskProvider: taskProvider)
    }
    
    func makeTaskViewModel(taskAction: TaskAction) -> TaskViewModel {
        return TaskViewModel(taskAction: taskAction, taskProvider: taskProvider)
    }
    
    func makeNotificationService() -> NotificationService {
        return NotificationService(taskProvider: taskProvider)
    }
}

class MockFactory: FactoryProtocol {
    
    private lazy var taskProvider = InMemoryTaskProvider()

    func makeTaskListViewModel() -> TaskListViewModel {
        return TaskListViewModel(taskProvider: taskProvider)
    }
    
    func makeTaskViewModel(taskAction: TaskAction) -> TaskViewModel {
        return TaskViewModel(taskAction: taskAction, taskProvider: taskProvider)
    }
    
    func makeNotificationService() -> NotificationService {
        return NotificationService(taskProvider: taskProvider)
    }
}
