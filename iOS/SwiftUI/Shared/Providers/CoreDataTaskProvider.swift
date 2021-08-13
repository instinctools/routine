//
//  TaskProvider.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/6/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import CoreData
import Combine

protocol TaskProvider {
    var tasks: CurrentValueSubject<[Task], Never> { get }
    func addTask(_ task: Task)
    func updateTask(_ task: Task)
    func task(id: String) -> Task?
    func deleteTask(id: String)
}

private extension TaskEntity {
    func update(with task: Task) {
        id = task.id
        title = task.title
        period = task.period.rawValue
        periodCount = Int16(task.periodCount)
        startDate = task.startDate
        resetType = task.resetType.rawValue
    }
}

final class CoreDataTaskProvider: NSObject, TaskProvider {
    
    var tasks = CurrentValueSubject<[Task], Never>([])
    
    private let managedObjectContext: NSManagedObjectContext
    
    private let fetchedResultsController: NSFetchedResultsController<TaskEntity>
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TaskEntity.startDate), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.fetchedResultsController = controller
        
        super.init()
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
            tasks.value = controller.fetchedObjects?.map(Task.init) ?? []
        } catch {
            assertionFailure("\(#function): Failed to performFetch \(error)")
        }
    }
    
    func addTask(_ task: Task) {
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.update(with: task)
        saveContext()
    }
    
    func updateTask(_ task: Task) {
        do {
            if let taskUpdate = try getTaskEntity(by: task.id) {
                taskUpdate.update(with: task)
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    func deleteTask(id: String) {
        do {
            if let taskDelete = try getTaskEntity(by: id) {
                managedObjectContext.delete(taskDelete)
                saveContext()
            }
        } catch {
            log(error: error)
        }
    }
    
    func task(id: String) -> Task? {
        do {
            guard let entity = try getTaskEntity(by: id) else { return nil }
            return Task(entity: entity)
        } catch {
            log(error: error)
            return nil
        }
    }
    
    private func getTaskEntity(by id: String) throws -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        return try managedObjectContext.fetch(fetchRequest).first
    }
    
    private func log(error: Error) {
        assertionFailure("Task Provider error: \(error)")
    }
    
    private func saveContext() {
        guard managedObjectContext.hasChanges else { return }
        
        do {
            try managedObjectContext.save()
        } catch {
            managedObjectContext.rollback()
        }
    }
}

extension CoreDataTaskProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let entities = controller.fetchedObjects as? [TaskEntity] else { return }
        tasks.value = entities.map(Task.init)
    }
}
