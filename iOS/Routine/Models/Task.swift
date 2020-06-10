//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

extension Optional where Wrapped == Task.ResetType {
    var orDefault: Task.ResetType {
        return self ?? .toPeriod
    }
}

struct Task: Equatable {
    
    enum ResetType: Int16 {
        case toPeriod
        case toDate
    }
    
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
    
    init(id: String, title: String, period: Period, periodCount: Int, startDate: Date, resetType: ResetType) {
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
        self.period = Period(rawValue: entity.period).orDefault
        self.periodCount = Int(entity.periodCount)
        self.startDate = entity.startDate.orToday
        self.resetType = ResetType(rawValue: entity.resetType).orDefault
    }
}
