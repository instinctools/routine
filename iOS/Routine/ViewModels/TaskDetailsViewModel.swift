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
    @Published private(set) var selectedPeriodCount: String
    @Published var title: String
        
    private var cancellables: Set<AnyCancellable> = []
    
    private let task: Task?
    private let repository: TasksRepository
    private let taskNotificationCenter: TasksNotificationCenter
    
    init(task: Task? = nil, repository: TasksRepository, taskNotificationCenter: TasksNotificationCenter) {
        self.task = task
        self.repository = repository
        self.taskNotificationCenter = taskNotificationCenter
        
        self.doneButtonIsEnabled = false
        self.selectedPeriod = task?.period
        self.selectedPeriodCount = String(task?.periodCount ?? 0)
        self.title = task?.title ?? ""
        
        Publishers.CombineLatest($title, $selectedPeriod)
            .map { !$0.isEmpty && $1 != nil }
            .assign(to: \.doneButtonIsEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func setPeriod(_ period: Period, count: String) {
        self.selectedPeriod = period
        self.selectedPeriodCount = count
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
                periodCount: Int(selectedPeriodCount),
                startDate: task.startDate
            )
            self.repository.update(task: task)
            self.taskNotificationCenter.addNotification(forTask: task)
        } else {
            let task = Task(
                title: title,
                period: period,
                periodCount: Int(selectedPeriodCount)
            )
            self.repository.add(task: task)
            self.taskNotificationCenter.addNotification(forTask: task)
        }
    }
}
