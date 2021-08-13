//
//  Task.swift
//  Task
//
//  Created by Vadim Koronchik on 29.07.21.
//

import UIKit

struct Task: Equatable, Hashable, Identifiable {
    
    let id: String
    let title: String
    let period: Period
    let periodCount: Int
    let startDate: Date
    let resetType: ResetType
    
    var finishDate: Date {
        return Calendar.current.date(
            byAdding: period.calendarComponent,
            value: periodCount,
            to: startDate
        ).orToday
    }
    
    init(id: String,
         title: String,
         period: Period,
         periodCount: Int,
         startDate: Date,
         resetType: ResetType) {
        
        self.id = id
        self.title = title
        self.period = period
        self.periodCount = periodCount
        self.startDate = startDate
        self.resetType = resetType
    }
    
    init(entity: TaskEntity) {
        self.id = entity.id.orEmpty
        self.title = entity.title.orEmpty
        self.period = Period(rawValue: entity.period.orEmpty).orDefault
        self.periodCount = Int(entity.periodCount)
        self.startDate = entity.startDate.orToday
        self.resetType = ResetType(rawValue: entity.resetType.orEmpty).orDefault
    }
}

extension Task {
    enum ResetType: String, CaseIterable {
        case byPeriod = "BY_PERIOD"
        case byDate = "BY_DATE"
        
        var index: Int {
            switch self {
            case .byPeriod:
                return 0
            case .byDate:
                return 1
            }
        }
        
        init(indexValue: Int) {
            switch indexValue {
            case 0:
                self = .byPeriod
            default:
                self = .byDate
            }
        }
    }
}

extension Task {
    static let mock: Task = .init(
        id: UUID().uuidString,
        title: "Reed a book",
        period: .day,
        periodCount: 2,
        startDate: Date(),
        resetType: .byPeriod
    )
    static let mock2: Task = .init(
        id: UUID().uuidString,
        title: "Watch films",
        period: .week,
        periodCount: 1,
        startDate: Date().addingTimeInterval(-1000000000),
        resetType: .byDate
    )
}

extension Task {    
    static func reset(task: Task) -> Task {
        let resetType = task.resetType
        let startDate: Date
        
        switch resetType {
        case .byPeriod:
            startDate = Date()
        case .byDate:
            let calendar = Calendar.current
            
            let maxPossibleStartDate = calendar.date(
                byAdding: task.period.calendarComponent,
                value: task.periodCount / 2,
                to: Date()
            ).orToday
            
            guard task.startDate < maxPossibleStartDate else {
                return task
            }
            
            let minPossibleStartDate = calendar.date(
                byAdding: task.period.calendarComponent,
                value: -task.periodCount,
                to: Date()
            ).orToday
            
            var newStartDate = task.startDate
            repeat {
                newStartDate = calendar.date(
                    byAdding: task.period.calendarComponent,
                    value: task.periodCount,
                    to: newStartDate
                ).orToday
            } while newStartDate < minPossibleStartDate
            
            startDate = newStartDate
        }
        return Task(id: task.id,
                    title: task.title,
                    period: task.period,
                    periodCount: task.periodCount,
                    startDate: startDate,
                    resetType: task.resetType)
    }
}
