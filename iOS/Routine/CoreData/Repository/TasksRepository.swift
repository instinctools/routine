//
//  TaskRepository.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/26/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import CoreData

final class TasksRepository {
    
    private let persistentContainer: NSPersistentContainer
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    static var shared = TasksRepository()
    
    private init() {
        self.persistentContainer = {
            let container = NSPersistentContainer(name: "Routine")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    }
    
    func getAllTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let tasks: [Task] = try context.fetch(fetchRequest).map { entity in
                return .init(
                    id: entity.id ?? UUID(),
                    title: entity.title ?? "",
                    period: Period(rawValue: Int(entity.period)) ?? .day,
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
    
    func resetTask(id: UUID) -> Task? {
        do {
            if let taskUpdate = try getTasks(withId: id) {
                taskUpdate.startDate = .init()
                saveContext()
                return .init(
                    id: id,
                    title: taskUpdate.title ?? "",
                    period: Period(rawValue: Int(taskUpdate.period)) ?? .day,
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
            if let taskUpdate = try getTasks(withId: task.id) {
                taskUpdate.title = task.title
                taskUpdate.period = Int16(task.period.rawValue)
                taskUpdate.startDate = task.startDate
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    func deleteTask(byId id: UUID) {
        do {
            if let taskDelete = try getTasks(withId: id) {
                context.delete(taskDelete)
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    private func getTasks(withId id: UUID) throws -> TaskEntity? {
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
