//
//  TaskViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

struct TaskViewModel {
    
    let task: Task
    var color: UIColor
    
    var title: String {
        return task.title
    }
    
    var period: String {
        return "Every " + task.period.fullTitle(periodCount: task.periodCount)
    }
    
    var timeLeft: String {
        if daysLeft < -2 {
            return "\(daysLeft) days ago"
        } else if daysLeft < -1 {
            return "Yesterday"
        } else if daysLeft == 0 {
            return "Today"
        } else if daysLeft == 1 {
            return "Tomorrow"
        } else if (2..<7).contains(daysLeft) {
            return "\(daysLeft) days left"
        } else if daysLeft == 7 {
            return "1 week left"
        }
        return ""
    }
    
    private var daysLeft: Int {
        return Calendar.current.dateComponents([.day], from: task.startDate, to: task.finishDate).day!
    }
        
    init(task: Task, color: UIColor) {
        self.task = task
        self.color = color
    }
}

extension TaskViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(task.id)
        hasher.combine(task.period.rawValue)
        hasher.combine(task.title)
        hasher.combine(color)
    }

    static func ==(lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.task.id == rhs.task.id &&
            lhs.task.period.rawValue == rhs.task.period.rawValue &&
            lhs.task.title == rhs.task.title &&
            lhs.color == rhs.color
    }
}
