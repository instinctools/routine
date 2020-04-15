//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

struct Task: Hashable {
    
    var id = UUID()
    let title: String
    let period: Period
    var startDate = Date()
    
    var finishDate: Date {
        return period.calculateDate(withStardDate: startDate)
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
