//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

struct Task {
    
    let id: UUID
    let title: String
    let period: Period
    let periodCount: Int?
    var startDate: Date
    
    var finishDate: Date {
        return period.calculateDate(withStardDate: startDate, periodCount: periodCount)
    }
    
    init(id: UUID = UUID(), title: String, period: Period, periodCount: Int?, startDate: Date = Date()) {
        self.id = id
        self.title = title
        self.period = period
        self.periodCount = periodCount
        self.startDate = startDate
    }
}

extension Task {
    static let mock: Task = .init(
        title: "Attend a pool",
        period: .day,
        periodCount: 2
    )
    static let mock2: Task = .init(
        title: "Attend a Church",
        period: .week,
        periodCount: 0
    )
}
