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
        return .init(red: 255, green: CGFloat(30*index)/255, blue: 0, alpha: 1.0)
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
    
    private var colors: [UIColor] = [
        UIColor.systemRed,
        UIColor.systemPink,
        UIColor.systemOrange,
        UIColor.systemYellow
    ]
    
    private var daysLeft: Int {
        return Calendar.current.dateComponents([.day], from: task.startDate, to: task.finishDate).day!
    }
    
    let task: Task
    private let index: Int
    
    init(task: Task, index: Int) {
        self.task = task
        self.title = task.title
        self.period = task.period.title
        self.index = index
    }
}
