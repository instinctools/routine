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
        let title: AnyPublisher<String, Never>
        let doneButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let title: AnyPublisher<String, Never>
        let doneButtonIsEnabled: AnyPublisher<Bool, Never>
        let onClose: AnyPublisher<Void, Never>
    }
    
    private(set) var title: AnyPublisher<String, Never>?
    private(set) var doneButtonIsEnabled: CurrentValueSubject<Bool, Never>
    @Published private(set) var selectedPeriod: Period?
        
    private let task: Task?
    private let repository = TasksRepository()
    private var cancellables: Set<AnyCancellable> = []
    
    init(task: Task? = nil) {
        self.task = task
        self.selectedPeriod = task?.period
        self.doneButtonIsEnabled = .init(false)
    }
    
    func setPeriod(_ period: Period) {
        self.selectedPeriod = period
    }
    
    func transform(input: Input) -> Output {
        let taskPublisher = Publishers.CombineLatest(input.title, $selectedPeriod)
        
        let titleSubject = CurrentValueSubject<String, Never>(task?.title ?? "")
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
        
        return .init(title: titleSubject.eraseToAnyPublisher(),
                     doneButtonIsEnabled: doneButtonIsEnabled,
                     onClose: onClosePublisher)
    }
}
