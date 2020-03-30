//
//  TaskRepository.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/26/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import CoreData

class TasksRepository {
    
    private let persistentContainer: NSPersistentContainer
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    init() {
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
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getAllTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let tasks: [Task] = try context.fetch(fetchRequest).map { entity in
                return .init(
                    id: entity.id ?? UUID(),
                    title: entity.title ?? "",
                    period: Period(rawValue: Int(entity.period)) ?? .day
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
    
    func update(task: Task) {
        do {
            if let taskUpdate = try getTasks(withId: task.id) {
                taskUpdate.setValue(task.title, forKey: "title")
                taskUpdate.setValue(task.period.rawValue, forKey: "period")
                taskUpdate.setValue(task.startDate, forKey: "startDate")
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    func delete(task: Task) {
        do {
            if let taskDelete = try getTasks(withId: task.id) {
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
