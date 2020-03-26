//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Foundation

struct Test {
    
}

class Task {
    
    var id: UUID
    var title: String
    var period: Period
    var startDate: Date
    
    private var colors: [UIColor] = [
        UIColor.systemRed,
        UIColor.systemPink,
        UIColor.systemOrange,
        UIColor.systemYellow
    ]
    
    private var daysLeft: Int {
        return calculateTimeLeft(start: startDate, end: endDate)
    }
    
    var color: UIColor {
        if daysLeft < 0 {
            return colors[0]
        } else if daysLeft < 2 {
            return colors[1]
        } else if daysLeft < 6 {
            return colors[2]
        }
        return colors[3]
    }
    
    var timeLeft: String {
        let weekDays = 7
        if daysLeft == 0 {
            return "Today"
        } else if daysLeft == 1 {
            return "Tomorrow"
        } else if (2...weekDays-1).contains(daysLeft) {
            return "\(daysLeft) days left"
        } else if (weekDays...weekDays*2-1).contains(daysLeft) {
            return "1 week left"
        }
        return ""
    }

    
    private var endDate: Date {
        return period.calculateDate(withStardDate: startDate)
    }

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()

    init(id: UUID = UUID(), title: String, period: Period) {
        self.id = id
        self.title = title
        self.period = period
        let now = Date()
        self.startDate = now
    }
    
    func reset() {
        self.startDate = Date()
    }
    
    private func calculateTimeLeft(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
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
