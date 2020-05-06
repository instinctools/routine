//
//  TaskDetailsViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Combine
import CoreData
import Foundation

final class TaskDetailsViewModel: NSObject {
    
    @Published private(set) var doneButtonIsEnabled: Bool
    @Published private(set) var selectedPeriod: Period?
    @Published private(set) var selectedPeriodCount: String
    @Published var title: String
        
    private var cancellables: Set<AnyCancellable> = []
    
    private let task: Task?
    
    private lazy var taskProvier: TaskProvider = {
        let container = CoreDataManager.shared.persistentContainer
        let provider = TaskProvider(persistentContainer: container)
        return provider
    }()
    
    init(task: Task? = nil) {
        self.task = task
        self.doneButtonIsEnabled = false
        self.selectedPeriod = task?.period
        self.selectedPeriodCount = String(task?.periodCount ?? 0)
        self.title = (task?.title).orEmpty
        super.init()
        
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
        
        let periodCount = Int(selectedPeriodCount) ?? 1
        if let task = self.task {
            let task = Task(
                id: task.id,
                title: title,
                period: period,
                periodCount: periodCount,
                startDate: task.startDate
            )
            self.taskProvier.update(task: task)
        } else {
            let task = Task(
                id: UUID().uuidString,
                title: title,
                period: period,
                periodCount: periodCount
            )
            self.taskProvier.add(task: task)
        }
    }
}
