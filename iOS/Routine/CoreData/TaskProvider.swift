//
//  TaskProvider.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/6/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import CoreData

extension Task {
    static let mock: Task = .init(
        id: UUID().uuidString,
        title: "Attend a pool",
        period: .day,
        periodCount: 2,
        finishDate: Date()
    )
    static let mock2: Task = .init(
        id: UUID().uuidString,
        title: "Attend a Church",
        period: .week,
        periodCount: 1,
        finishDate: Date()
    )
}

private extension TaskEntity {
    func update(from task: Task) {
        id = task.id
        title = task.title
        period = Int16(task.period.rawValue)
        periodCount = Int16(task.periodCount)
        finishDate = task.finishDate
    }
}

final class TaskProvider {
    
    private var persistentContainer: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TaskEntity> = {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TaskEntity.finishDate), ascending: true)
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
    
    func getAllTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest).map(Task.init)
        } catch {
            log(error: error)
        }
        return []
    }

    func add(task: Task) {
        let taskEntity = TaskEntity(context: context)
        taskEntity.update(from: task)
        saveContext()
    }
    
    func resetTask(id: String) {
        do {
            if let taskUpdate = try getTasks(withId: id) {
                let period = Period(rawValue: Int(taskUpdate.period)).orDefault
                let periodCount = Int(taskUpdate.periodCount)
                let finishDate = taskUpdate.finishDate.orToday
                let calendar = Calendar.current
                
                let startDate = calendar.date(
                    byAdding: period.calendarComponent,
                    value: -periodCount,
                    to: finishDate
                ).orToday
                
                let intervalComponent = Calendar.Component.day
                let fromStartToFinishDateInterval = calendar.dateComponents(
                    [intervalComponent],
                    from: startDate,
                    to: finishDate
                ).day ?? 0
                let fromFinishToTodayDateInterval = calendar.dateComponents(
                    [intervalComponent],
                    from: finishDate,
                    to: Date()
                ).day ?? 0
                
                if fromFinishToTodayDateInterval >= fromStartToFinishDateInterval {
                    let interval = fromFinishToTodayDateInterval % fromStartToFinishDateInterval
                    taskUpdate.finishDate = calendar.date(
                        byAdding: intervalComponent,
                        value: interval,
                        to: Date()
                    ).orToday
                } else {
                    taskUpdate.finishDate = calendar.date(
                        byAdding: period.calendarComponent,
                        value: periodCount,
                        to: taskUpdate.finishDate.orToday
                    ).orToday
                }
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    func update(task: Task) {
        do {
            if let taskUpdate = try getTasks(withId: task.id) {
                taskUpdate.update(from: task)
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    func deleteTask(byId id: String) {
        do {
            if let taskDelete = try getTasks(withId: id) {
                context.delete(taskDelete)
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    private func getTasks(withId id: String) throws -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        return try context.fetch(fetchRequest).first
    }
    
    func log(error: Error) {
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
