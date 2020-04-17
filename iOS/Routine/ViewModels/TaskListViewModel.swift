//
//  TaskListViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation
import Combine
import UIKit

final class TaskListViewModel {
    
    private var allTasks: [Task] = []
    private var allTasksViewModels: Set<TaskViewModel> = []
    private var tasksSections: [Int: [TaskViewModel]] = [:]

    var expiredTasks: [TaskViewModel] {
        return tasksSections[0] ?? []
    }
    var futureTasks: [TaskViewModel] {
        return tasksSections[1] ?? []
    }
    
    private let repository = TasksRepository()
    
    func getTask(at indexPath: IndexPath) -> TaskViewModel {
        return (tasksSections[indexPath.section] ?? [])[indexPath.row]
    }
    
    func resetTask(at indexPath: IndexPath) {
        var task = getTask(at: indexPath).task
        task.startDate = .init()
        repository.update(task: task)
        refreshData()
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let task = getTask(at: indexPath).task
        tasksSections[indexPath.section]?.remove(at: indexPath.row)
        repository.delete(task: task)
    }
    
    func reloadColors() {
        let tasks = repository.getAllTasks().sorted { $0.finishDate < $1.finishDate }
        
        var futureTasks: [TaskViewModel] = []
        var expiredTasks: [TaskViewModel] = []
        
        for index in 0..<tasks.count {
            let task = tasks[index]
            let interval = min(220 / tasks.count, 30)
            let color = UIColor(red: 255, green: CGFloat(index*interval)/255, blue: 0, alpha: 1.0)
            let viewModel = TaskViewModel(task: task, color: color)
            
            if task.finishDate < Date() {
                expiredTasks.append(viewModel)
            } else {
                futureTasks.append(viewModel)
            }
        }
        
        self.tasksSections[0] = expiredTasks
        self.tasksSections[1] = futureTasks
        self.allTasks = tasks
        self.allTasksViewModels = Set(expiredTasks + futureTasks)
    }
    
    func refreshData() {
        if allTasks.isEmpty {
            reloadColors()
            return
        }
        let tasks = repository.getAllTasks().sorted { $0.finishDate < $1.finishDate }
        
        if allTasks == tasks {
            return
        }
        
        var futureTasks: [TaskViewModel] = []
        var expiredTasks: [TaskViewModel] = []
        
        for index in 0..<tasks.count {
            let task = tasks[index]
            
            let oldViewModel = allTasksViewModels.first(where: { $0.task.id == task.id })
            let color = oldViewModel?.color ?? .red
            let viewModel = TaskViewModel(task: task, color: color)
            
            if task.finishDate < Date() {
                expiredTasks.append(viewModel)
            } else {
                futureTasks.append(viewModel)
            }
        }
        
        self.tasksSections[0] = expiredTasks
        self.tasksSections[1] = futureTasks
        self.allTasks = tasks
        self.allTasksViewModels = Set(expiredTasks + futureTasks)
    }
}
