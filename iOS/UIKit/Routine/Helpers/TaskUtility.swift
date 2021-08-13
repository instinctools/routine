//
//  TaskUtility.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/19/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation

struct TaskUtility {
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
