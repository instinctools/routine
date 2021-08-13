//
//  Factory.swift
//  Factory
//
//  Created by Vadim Koronchik on 12.08.21.
//

import Foundation

final class Factory: FactoryProtocol {
    
    private lazy var taskProvider = CoreDataTaskProvider(
        managedObjectContext: CoreDataStack.shared.mainContext
    )
    
    func makeTaskListViewModel() -> TaskListViewModel {
        return TaskListViewModel(taskProvider: taskProvider)
    }
}

final class MockFactory: FactoryProtocol {
    
    private lazy var taskProvider = InMemoryTaskProvider()
    
    func makeTaskListViewModel() -> TaskListViewModel {
        return TaskListViewModel(taskProvider: taskProvider)
    }
}
