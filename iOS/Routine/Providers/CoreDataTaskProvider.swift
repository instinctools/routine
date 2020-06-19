//
//  TaskProvider.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/6/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import CoreData

extension Task {
    static let mock: Task = .init(
        id: UUID().uuidString,
        title: "Attend a pool",
        period: .day,
        periodCount: 2,
        startDate: Date(),
        resetType: .byPeriod
    )
    static let mock2: Task = .init(
        id: UUID().uuidString,
        title: "Attend a Church",
        period: .week,
        periodCount: 1,
        startDate: Date(),
        resetType: .byDate
    )
}

protocol TaskProvider {
    func getAllTasks(completion: @escaping ([Task]) -> Void)
    func add(task: Task)
    func resetTask(id: String, completion: ((Task?) -> Void)?)
    func update(task: Task)
    func deleteTask(byId id: String)
}

extension TaskProvider {
    func resetTask(id: String, completion: ((Task?) -> Void)? = nil) {
        resetTask(id: id, completion: completion)
    }
}

private extension TaskEntity {
    func update(from task: Task) {
        id = task.id
        title = task.title
        period = task.period.rawValue
        periodCount = Int16(task.periodCount)
        startDate = task.startDate
        resetType = task.resetType.rawValue
    }
}

final class CoreDataTaskProvider: TaskProvider {
    
    private let persistentContainer: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TaskEntity> = {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TaskEntity.startDate), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            try controller.performFetch()
        } catch {
            assertionFailure("\(#function): Failed to performFetch \(error)")
        }
        
        return controller
    }()
    
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate? {
        didSet {
            fetchedResultsController.delegate = fetchedResultsControllerDelegate
        }
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getAllTasks(completion: @escaping ([Task]) -> Void) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest).map(Task.init)
            completion(tasks)
        } catch {
            log(error: error)
            completion([])
        }
    }
    
    func add(task: Task) {
        let taskEntity = TaskEntity(context: context)
        taskEntity.update(from: task)
        saveContext()
    }
    
    func resetTask(id: String, completion: ((Task?) -> Void)?) {
        do {
            if let taskUpdate = try getTaskEntity(byId: id) {
                let task = Task(entity: taskUpdate)
                let resetedTask = TaskUtility.reset(task: task)
                taskUpdate.update(from: resetedTask)
                saveContext()
                completion?(resetedTask)
            }
        } catch {
            log(error: error)
        }
        completion?(nil)
    }
    
    func update(task: Task) {
        do {
            if let taskUpdate = try getTaskEntity(byId: task.id) {
                taskUpdate.update(from: task)
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    func deleteTask(byId id: String) {
        do {
            if let taskDelete = try getTaskEntity(byId: id) {
                context.delete(taskDelete)
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    private func getTaskEntity(byId id: String) throws -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        return try context.fetch(fetchRequest).first
    }
    
    private func log(error: Error) {
        assertionFailure("Task Provider error: \(error)")
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
