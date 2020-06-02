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
    let finishDate: Date
    
    init(id: String, title: String, period: Period, periodCount: Int, finishDate: Date) {
        self.id = id
        self.title = title
        self.period = period
        self.periodCount = periodCount
        self.finishDate = finishDate
    }
    
    init(entity: TaskEntity) {
        self.id = entity.id.orEmpty
        self.title = entity.title.orEmpty
        self.period = Period(rawValue: Int(entity.period)).orDefault
        self.periodCount = Int(entity.periodCount)
        self.finishDate = entity.finishDate.orToday
    }
}
