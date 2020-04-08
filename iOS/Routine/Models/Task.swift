//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

struct Task: Hashable {
    
    var id: UUID
    var title: String
    var period: Period
    var startDate: Date
    
    var finishDate: Date {
        return period.calculateDate(withStardDate: startDate)
    }

    init(id: UUID = UUID(), title: String, period: Period, startDate: Date = Date()) {
        self.id = id
        self.title = title
        self.period = period
        self.startDate = startDate
    }
}

extension Task {
    static let mock: Task = .init(
        title: "Attend a pool",
        period: .day
    )
    static let mock2: Task = .init(
        title: "Attend a Church",
        period: .week
    )
}
