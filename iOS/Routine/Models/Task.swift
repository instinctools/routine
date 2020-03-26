//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation

class Task {
    
    var title: String
    var repeatPeriod: String
    var executionTime: String

    init(title: String, repeatPeriod: String, executionTime: String) {
        self.title = title
        self.repeatPeriod = repeatPeriod
        self.executionTime = executionTime
    }
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
