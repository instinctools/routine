//
//  TaskViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Combine

class TaskViewModel {
    
    var title: String
    var period: String
    
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
    
    private var colors: [UIColor] = [
        UIColor.systemRed,
        UIColor.systemPink,
        UIColor.systemOrange,
        UIColor.systemYellow
    ]
    
    private var endDate: Date {
        return task.period.calculateDate(withStardDate: task.startDate)
    }
    
    private var daysLeft: Int {
        return calculateTimeLeft(start: task.startDate, end: endDate)
    }
    
    let task: Task
    
    init(task: Task) {
        self.task = task
        self.title = task.title
        self.period = task.period.title
    }
    
    func reset() {
        task.startDate = Date()
    }
    
    private func calculateTimeLeft(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
}
