//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

class Task {
    
    var id: UUID
    var title: String
    var period: Period
    var startDate: Date

    init(id: UUID = UUID(), title: String, period: Period) {
        self.id = id
        self.title = title
        self.period = period
        let now = Date()
        self.startDate = now
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
