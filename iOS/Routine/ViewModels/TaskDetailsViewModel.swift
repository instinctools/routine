//
//  TaskDetailsViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Combine

final class TaskDetailsViewModel {
    
    @Published private(set) var doneButtonIsEnabled: Bool
    @Published private(set) var selectedPeriod: Period?
    @Published var title: String
        
    private let task: Task?
    private let repository = TasksRepository()
    private var cancellables: Set<AnyCancellable> = []
    
    init(task: Task? = nil) {
        self.doneButtonIsEnabled = false
        self.task = task
        self.selectedPeriod = task?.period
        self.title = task?.title ?? ""
        
        Publishers.CombineLatest($title, $selectedPeriod)
            .map { !$0.isEmpty && $1 != nil }
            .assign(to: \.doneButtonIsEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func setPeriod(_ period: Period) {
        self.selectedPeriod = period
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func saveTask() {
        guard let period = selectedPeriod else { return }
        
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
    }
}
