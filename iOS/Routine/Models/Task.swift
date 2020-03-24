//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation

struct Task {
    var title: String
    var repeatPeriod: String
    var executionTime: String
}

extension Task {
    static let mock: Task = .init(
        title: "Attend a pool",
        repeatPeriod: "Every four days",
        executionTime: "Yesterday"
    )
    static let mock2: Task = .init(
        title: "Attend a Church",
        repeatPeriod: "Every day",
        executionTime: "Today"
    )
}
