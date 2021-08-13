//
//  TaskListViewModel.swift
//  TaskListViewModel
//
//  Created by Vadim Koronchik on 29.07.21.
//

import Foundation
import Combine
import SwiftUI

final class TaskListViewModel: ObservableObject {
    
    @Published var items = [TaskListModel]()
    
    private let taskProvider: TaskProvider
    
    init(taskProvider: TaskProvider) {
        self.taskProvider = taskProvider
        
        taskProvider.tasks
            .map { tasks in
                let tasks = tasks.sorted { $0.finishDate < $1.finishDate }
                var futureTasks: [TaskListModel] = []
                var expiredTasks: [TaskListModel] = []
                let tasksCount = tasks.count
                
                for index in 0..<tasksCount {
                    let task = tasks[index]
                    let color = self.makeColor(tasksCount: tasksCount, index: index)
                    let viewModel = TaskListModel.item(.init(color: color, task: task))
                    if task.finishDate < Date() {
                        expiredTasks.append(viewModel)
                    } else {
                        futureTasks.append(viewModel)
                    }
                }
                
                let items: [TaskListModel] = {
                    if !expiredTasks.isEmpty && !futureTasks.isEmpty {
                        return expiredTasks + [.divider] + futureTasks
                    }
                    return expiredTasks + futureTasks
                }()
                
                return items
            }
            .eraseToAnyPublisher()
            .assign(to: &$items)
    }
    
    func deleteTask(_ task: TaskRowModel) {
        taskProvider.deleteTask(id: task.task.id)
    }
    
    func resetTask(_ task: TaskRowModel) {
        let resettedTask = Task.reset(task: task.task)
        taskProvider.updateTask(resettedTask)
    }
    
    private func makeColor(tasksCount: Int, index: Int) -> Color {
        let interval = min(220 / tasksCount, 30)
        let color = Color(red: 1, green: CGFloat(index*interval)/255, blue: 0)
        return color
    }
}
