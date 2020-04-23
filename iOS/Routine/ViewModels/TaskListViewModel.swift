//
//  TaskListViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

final class TaskListViewModel {
    
    private var tasks: [Task] = []
    private var tasksSections: [Int: [TaskViewModel]] = [:]

    var expiredTasks: [TaskViewModel] {
        return tasksSections[0] ?? []
    }
    var futureTasks: [TaskViewModel] {
        return tasksSections[1] ?? []
    }
    
    let repository: TasksRepository
    let taskNotificationCenter: TasksNotificationCenter
    
    init(repository: TasksRepository, taskNotificationCenter: TasksNotificationCenter) {
        self.repository = repository
        self.taskNotificationCenter = taskNotificationCenter
    }
    
    func getTask(at indexPath: IndexPath) -> TaskViewModel {
        return (tasksSections[indexPath.section] ?? [])[indexPath.row]
    }
    
    func resetTask(at indexPath: IndexPath) {
        guard let task = repository.resetTask(id: getTask(at: indexPath).task.id) else { return }
        taskNotificationCenter.addNotification(forTask: task)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let taskId = getTask(at: indexPath).task.id
        tasks.removeAll(where: { $0.id == taskId })
        tasksSections[indexPath.section]?.remove(at: indexPath.row)
        
        repository.deleteTask(byId: taskId)
        taskNotificationCenter.removeNotification(withId: taskId.uuidString)
    }
    
    func reloadColors() {
        let tasksCount = tasksSections.values.joined().count
        for (key, _) in tasksSections {
            for i in 0..<(tasksSections[key]?.count ?? 0) {
                guard let task = tasksSections[key]?[i].task,
                    let index = tasks.firstIndex(where: { $0.id == task.id }) else { continue }
                
                tasksSections[key]?[i].color = makeColor(tasksCount: tasksCount, index: index)
            }
        }
    }
    
    func refreshData() {
        let newTasks = repository.getAllTasks().sorted { $0.finishDate < $1.finishDate }
        
        var futureTasks: [TaskViewModel] = []
        var expiredTasks: [TaskViewModel] = []
        
        let tasksCount = newTasks.count
        let oldViewModels = tasksSections.values.joined()
        
        for index in 0..<tasksCount {
            let task = newTasks[index]
            var newViewModel: TaskViewModel
            
            if let oldViewModel = oldViewModels.first(where: { $0.task.id == task.id }) {
                let color = oldViewModel.color
                newViewModel = TaskViewModel(task: task, color: color)
            } else {
                let color = makeColor(tasksCount: tasksCount, index: index)
                newViewModel = TaskViewModel(task: task, color: color)
            }
            
            if task.finishDate < Date() {
                expiredTasks.append(newViewModel)
            } else {
                futureTasks.append(newViewModel)
            }
        }
        
        self.tasks = newTasks
        self.tasksSections[0] = expiredTasks
        self.tasksSections[1] = futureTasks
    }
    
    private func makeColor(tasksCount: Int, index: Int) -> UIColor {
        let interval = min(220 / tasksCount, 30)
        let color = UIColor(red: 255, green: CGFloat(index*interval)/255, blue: 0, alpha: 1.0)
        return color
    }
}
