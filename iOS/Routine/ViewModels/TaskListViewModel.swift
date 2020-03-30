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
    private(set) var tasks: [Task] = []
    
    var tasksCount: Int {
        return tasks.count
    }
    
    private let repository = TasksRepository()
    
    func resetTask(at index: Int) {
        let task = tasks[index]
        task.startDate = Date()
        repository.update(task: task)
        refreshData()
    }
    
    func deleteTask(at index: Int) {
        let task = tasks[index]
        tasks.remove(at: index)
        repository.delete(task: task)
    }
    
    func task(at index: Int) -> Task {
        return tasks[index]
    }
    
    func refreshData() {
        tasks = repository.getAllTasks()
        objectWillChange.send()
    }
}
