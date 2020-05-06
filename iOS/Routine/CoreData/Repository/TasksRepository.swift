//
//  TaskRepository.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/26/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import CoreData

final class TasksRepository {
    
    private let persistentContainer: NSPersistentCloudKitContainer
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    static var shared = TasksRepository()
    
    private init() {
        self.persistentContainer = {
            let container = NSPersistentCloudKitContainer(name: "Routine")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.automaticallyMergesChangesFromParent = true
            return container
        }()
    }
    
    func getAllTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let tasks: [Task] = try context.fetch(fetchRequest).map { entity in
                var periodCount: Int?
                if let count = entity.periodCount {
                    periodCount = count.intValue
                }
                return .init(
                    id: entity.id.orEmpty,
                    title: entity.title.orEmpty,
                    period: Period(rawValue: Int(entity.period)) ?? .day,
                    periodCount: periodCount,
                    startDate: entity.startDate ?? .init()
                )
            }
            return tasks
        } catch {
            log(error: error)
        }
        return []
    }

    func add(task: Task) {
        let taskEntity = TaskEntity(context: context)
        taskEntity.id = task.id
        taskEntity.title = task.title
        taskEntity.period = Int16(task.period.rawValue)
        taskEntity.startDate = task.startDate
        saveContext()
    }
    
    func resetTask(id: String) -> Task? {
        do {
            if let taskUpdate = try getTasks(withId: id) {
                var periodCount: Int?
                if let count = taskUpdate.periodCount {
                    periodCount = count.intValue
                }
                taskUpdate.startDate = .init()
                saveContext()
                return .init(
                    id: id,
                    title: taskUpdate.title.orEmpty,
                    period: Period(rawValue: Int(taskUpdate.period)) ?? .day,
                    periodCount: periodCount,
                    startDate: taskUpdate.startDate ?? .init()
                )
            }
        } catch {
            log(error: error)
        }
        return nil
    }
    
    func update(task: Task) {
        do {
            var periodCount: NSNumber?
            if let count = task.periodCount {
                periodCount = NSNumber(value: count)
            }
            if let taskUpdate = try getTasks(withId: task.id) {
                taskUpdate.title = task.title
                taskUpdate.period = Int16(task.period.rawValue)
                taskUpdate.periodCount = periodCount
                taskUpdate.startDate = task.startDate
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
        print("Task Repository ERROR: ", error.localizedDescription)
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
