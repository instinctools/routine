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
        let tasks: Driver<[TasksTableSection]>
        let taskSelected: Driver<Task>
        let placeholder: Driver<UIImage?>
    }
    
    private let taskProvier: TaskProvider = FirebaseTaskProvider()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let tasks = PublishSubject<[TasksTableSection]>()
        
        input.didResetTaskDriver
            .flatMap { [weak self] viewModel in
                self?.resetTask(viewModel: viewModel) ?? .just(())
            }
            .flatMap { [weak self] in
                self?.refreshTasks() ?? .just([])
            }
            .bind(to: tasks)
            .disposed(by: disposeBag)
        
        input.didDeleteTaskDriver
            .map { [weak self] viewModel in
                self?.deleteTask(viewModel: viewModel)
            }
            .flatMap { [weak self] in
                self?.refreshTasks() ?? .just([])
            }
            .bind(to: tasks)
            .disposed(by: disposeBag)
        
        input.viewWillAppearDriver.asObservable()
            .flatMap { [weak self] in
                self?.refreshTasks() ?? .just([])
            }
            .bind(to: tasks)
            .disposed(by: disposeBag)
        
        let taskSelected: Driver<Task> = input.didTapCellDriver.map { $0.task }
        
        let placeholder = tasks.map { $0.flatMap({ $0.elements }).isEmpty }
            .distinctUntilChanged()
            .map { isEmpty in
                isEmpty ? UIImage(named: "placeholder") : nil
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Output(tasks: tasks.asDriver(onErrorJustReturn: []),
                      taskSelected: taskSelected,
                      placeholder: placeholder)
    }
    
    private func resetTask(viewModel: TaskViewModel) -> Single<Void> {
        return Single.create { (single) -> Disposable in
            self.taskProvier.resetTask(id: viewModel.task.id, completion: { _ in
                single(.success(()))
            })
            return Disposables.create()
        }
    }
    
    private func deleteTask(viewModel: TaskViewModel) {
        taskProvier.deleteTask(byId: viewModel.task.id)
    }

    private func refreshTasks() -> Single<[TasksTableSection]> {
        return Single.create { (single) -> Disposable in
            self.taskProvier.getAllTasks(completion: { tasks in
                let newTasks = tasks.sorted { $0.finishDate < $1.finishDate }
                var futureTasks: [TaskViewModel] = []
                var expiredTasks: [TaskViewModel] = []
                
                let tasksCount = newTasks.count
                
                for index in 0..<tasksCount {
                    let task = newTasks[index]
                    let color = self.makeColor(tasksCount: tasksCount, index: index)
                    let viewModel = TaskViewModel(task: task, color: color)
                    if task.finishDate < Date() {
                        expiredTasks.append(viewModel)
                    } else {
                        futureTasks.append(viewModel)
                    }
                }
                single(.success([
                    TasksTableSection(model: 0, elements: expiredTasks),
                    TasksTableSection(model: 1, elements: futureTasks)
                ]))
            })
            return Disposables.create()
        }
    }
    
    private func makeColor(tasksCount: Int, index: Int) -> UIColor {
        let interval = min(220 / tasksCount, 30)
        let color = UIColor(red: 255/255, green: CGFloat(index*interval)/255, blue: 0, alpha: 1.0)
        return color
    }
}
