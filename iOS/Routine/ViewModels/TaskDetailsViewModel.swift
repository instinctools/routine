//
//  TaskDetailsViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Combine

class TaskDetailsViewModel: ObservableObject {
    
    struct Input {
        let doneButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let doneButtonIsEnabled: AnyPublisher<Bool, Never>
        let onClose: AnyPublisher<Void, Never>
    }
    
    @Published private(set) var selectedPeriod: Period?
    @Published private(set) var title: String
        
    private let task: Task?
    private let repository = TasksRepository()
    private var cancellables: Set<AnyCancellable> = []
    
    init(task: Task? = nil) {
        self.task = task
        self.selectedPeriod = task?.period
        self.title = task?.title ?? ""
    }
    
    func setPeriod(_ period: Period) {
        self.selectedPeriod = period
    }
    
    func transform(input: Input) -> Output {
        let taskPublisher = Publishers.CombineLatest($title, $selectedPeriod)
        
        let doneButtonIsEnabled = taskPublisher
            .map { !$0.isEmpty && $1 != nil }
            .eraseToAnyPublisher()
        
        let onClosePublisher: AnyPublisher<Void, Never> = input.doneButtonDidTap
            .withLatestFrom(taskPublisher)
//            .flatMap { return taskPublisher }
            .map { [weak self] (title, period) in
                guard let `self` = self else { return }
                guard let period = period else { return }
                if let task = self.task {
                    let task = Task(
                        id: task.id,
                        title: title,
                        period: period,
                        startDate: task.startDate
                    )
                    self.repository.update(task: task)
                } else {
                    let task = Task(
                        title: title,
                        period: period
                    )
                    self.repository.add(task: task)
                }
                return ()
            }
            .eraseToAnyPublisher()
        
        return .init(doneButtonIsEnabled: doneButtonIsEnabled,
                     onClose: onClosePublisher)
    }
}
