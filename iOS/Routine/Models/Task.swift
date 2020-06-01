//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

struct Task: Equatable {
    
    let id: String
    let title: String
    let period: Period
    let periodCount: Int
    var startDate: Date
    
    var finishDate: Date {
        return Calendar.current.date(
            byAdding: period.calendarComponent,
            value: periodCount,
            to: startDate
        ).orToday
    }
    
    init(id: String, title: String, period: Period, periodCount: Int, startDate: Date = Date()) {
        self.id = id
        self.title = title
        self.period = period
        self.periodCount = periodCount
        self.startDate = startDate
    }
    
    init(entity: TaskEntity) {
        self.id = entity.id.orEmpty
        self.title = entity.title.orEmpty
        self.period = Period(rawValue: Int(entity.period)).orDefault
        self.periodCount = Int(entity.periodCount)
        self.startDate = entity.startDate.orToday
    }
}
