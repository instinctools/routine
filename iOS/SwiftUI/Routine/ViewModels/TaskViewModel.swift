//
//  TaskViewModel.swift
//  TaskViewModel
//
//  Created by Vadim Koronchik on 29.07.21.
//

import Combine
import Foundation
import SwiftUI

final class TaskViewModel: ObservableObject {
    
    @Published var title: String
    @Published var resetType: Task.ResetType
    @Published var selectedPeriod: PeriodViewModel
    @Published var periods: [PeriodViewModel]
    @Published var isValid = false
    
    private let taskAction: TaskAction
    private let taskProvider: TaskProvider
    
    init(taskAction: TaskAction, taskProvider: TaskProvider) {        
        self.taskAction = taskAction
        self.taskProvider = taskProvider
        
        let selectedPeriod: PeriodViewModel
        
        switch taskAction {
        case .create:
            title = ""
            resetType = .byPeriod
            selectedPeriod = .init(period: .day, periodCount: 1)
        case .edit(let task):
            title = task.title
            resetType = task.resetType
            selectedPeriod = .init(period: task.period, periodCount: task.periodCount)
        }
        
        self.selectedPeriod = selectedPeriod
        
        self.periods = Period.allCases.map { period in
            if period == selectedPeriod.period { return selectedPeriod }
            return .init(period: period, periodCount: 1)
        }
        
        Publishers.CombineLatest($title, self.selectedPeriod.$periodCount)
            .map { title, periodCount in
                return !title.isEmpty && periodCount > 0
            }
            .assign(to: &$isValid)
    }
    
    func period(at index: Int) -> PeriodViewModel {
        return periods[index]
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedPeriod.period == periods[index].period
    }
    
    func selectPeriod(at index: Int) {
        selectedPeriod = periods[index]
    }
    
    func updatePeriodCount(_ count: Int) {
        selectedPeriod.periodCount = count
    }
    
    func saveTask() {
        switch taskAction {
        case .create:
            let task = Task(id: UUID().uuidString,
                            title: title,
                            period: selectedPeriod.period,
                            periodCount: selectedPeriod.periodCount,
                            startDate: .init(),
                            resetType: resetType)
            taskProvider.addTask(task)
        case .edit(let task):
            let task = Task(id: task.id,
                            title: title,
                            period: selectedPeriod.period,
                            periodCount: selectedPeriod.periodCount,
                            startDate: task.startDate,
                            resetType: resetType)
            taskProvider.updateTask(task)
        }
    }
}
