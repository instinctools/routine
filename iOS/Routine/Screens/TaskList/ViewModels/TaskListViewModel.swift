//
//  TaskListViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreData

final class TaskListViewModel: NSObject {
    
    struct Input {
        let viewWillAppearDriver: Driver<Void>
        let didTapCellDriver: Driver<TaskViewModel>
        let didResetTaskDriver: Observable<TaskViewModel>
        let didDeleteTaskDriver: Observable<TaskViewModel>
    }
    
    struct Output {
        let tasks: PublishSubject<[TasksTableSection]>
        let taskSelected: Driver<Task>
    }
    
    private lazy var taskProvier: TaskProvider = {
        let container = CoreDataManager.shared.persistentContainer
        let provider = TaskProvider(persistentContainer: container)
        provider.fetchedResultsControllerDelegate = self
        return provider
    }()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let tasks = PublishSubject<[TasksTableSection]>()
        
        input.didResetTaskDriver
            .map(resetTask)
            .map(refreshTasks)
            .bind(to: tasks)
            .disposed(by: disposeBag)
        
        input.didDeleteTaskDriver
            .map(deleteTask)
            .map(refreshTasks)
            .bind(to: tasks)
            .disposed(by: disposeBag)
        
        input.viewWillAppearDriver
            .map(refreshTasks)
            .drive(tasks)
            .disposed(by: disposeBag)
        
        let taskSelected: Driver<Task> = input.didTapCellDriver.map { $0.task }
        
        return Output(tasks: tasks, taskSelected: taskSelected)
    }
    
    private func resetTask(viewModel: TaskViewModel) {
        taskProvier.resetTask(id: viewModel.task.id)
    }
    
    private func deleteTask(viewModel: TaskViewModel) {
        taskProvier.deleteTask(byId: viewModel.task.id)
    }

    private func refreshTasks() -> [TasksTableSection] {
        let newTasks = taskProvier.getAllTasks().sorted { $0.finishDate < $1.finishDate }
        
        var futureTasks: [TaskViewModel] = []
        var expiredTasks: [TaskViewModel] = []
        
        let tasksCount = newTasks.count
        
        for index in 0..<tasksCount {
            let task = newTasks[index]
            let color = makeColor(tasksCount: tasksCount, index: index)
            let viewModel = TaskViewModel(task: task, color: color)
            if task.finishDate < Date() {
                expiredTasks.append(viewModel)
            } else {
                futureTasks.append(viewModel)
            }
        }
        
        return [
            TasksTableSection(model: 0, elements: expiredTasks),
            TasksTableSection(model: 1, elements: futureTasks)
        ]
    }
    
    private func makeColor(tasksCount: Int, index: Int) -> UIColor {
        let interval = min(220 / tasksCount, 30)
        let color = UIColor(red: 255/255, green: CGFloat(index*interval)/255, blue: 0, alpha: 1.0)
        return color
    }
}

extension TaskListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        
    }
}
