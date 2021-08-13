//
//  InMemoryTaskProvider.swift
//  InMemoryTaskProvider
//
//  Created by Vadim Koronchik on 29.07.21.
//

import Combine

final class InMemoryTaskProvider: TaskProvider {
    
    var tasks = CurrentValueSubject<[Task], Never>([.mock, .mock2])
    
    func addTask(_ task: Task) {
        tasks.value.append(task)
    }
    
    func updateTask(_ task: Task) {
        let tasks: [Task] = tasks.value.map {
            if $0.id == task.id { return task }
            return $0
        }
        self.tasks.value = tasks
    }
    
    func task(id: String) -> Task? {
        return tasks.value.first { $0.id == id }
    }
    
    func deleteTask(id: String) {
        var tasks = self.tasks.value
        tasks.removeAll { $0.id == id }
        self.tasks.value = tasks
    }
}
