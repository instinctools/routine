//
//  TaskListViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    
    private var tasks: [Int: [Task]] = [:]

    var expiredTasks: [Task] {
        return tasks[0] ?? []
    }
    var futureTasks: [Task] {
        return tasks[1] ?? []
    }
    
    private let repository = TasksRepository()
    
    func getTask(at index: Int, section: Int) -> Task {
        return (tasks[section] ?? [])[index]
    }
    
    func resetTask(at index: Int, section: Int) {
        let task = getTask(at: index, section: section)
        let resetedTask = Task(
            id: task.id,
            title: task.title,
            period: task.period,
            startDate: Date()
        )
        repository.update(task: resetedTask)
        refreshData()
    }
    
    func deleteTask(at index: Int, section: Int) -> Task {
        let task = getTask(at: index, section: section)
        tasks[section]?.remove(at: index)
        repository.delete(task: task)
        return task
    }
    
    func refreshData() {
        self.tasks.removeAll()

        let tasks = repository.getAllTasks()
        var futureTasks: [Task] = []
        var expiredTasks: [Task] = []
        for task in tasks {
            if task.finishDate < Date() {
                expiredTasks.append(task)
            } else {
                futureTasks.append(task)
            }
        }
        self.tasks[0] = expiredTasks.sorted(by: { $0.finishDate < $1.finishDate })
        self.tasks[1] = futureTasks.sorted(by: { $0.finishDate < $1.finishDate })
                
        objectWillChange.send()
    }
}
