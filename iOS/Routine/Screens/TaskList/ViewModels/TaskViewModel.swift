//
//  TaskViewModel.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/27/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DifferenceKit

final class TaskViewModel {
    
    let color: BehaviorRelay<UIColor>
    let title = BehaviorRelay<String>(value: "")
    let period = BehaviorRelay<String>(value: "")
    let timeLeft = BehaviorRelay<String>(value: "")
    
    let task: Task
    
    private let disposeBag = DisposeBag()

    init(task: Task, color: UIColor) {
        self.task = task
        self.color = BehaviorRelay(value: color)
        
        self.title.accept(task.title)
        self.period.accept("Every " + task.period.fullTitle(periodCount: task.periodCount))
        self.timeLeft.accept(calculateTimeLeft())
    }
    
    private func calculateTimeLeft() -> String {
        if daysLeft < -30 {
            return "Expired"
        } else if daysLeft < -2 {
            return "\(abs(daysLeft)) days ago"
        } else if daysLeft < 0 {
            return "Yesterday"
        } else if daysLeft == 0 {
            if hoursLeft == 0 {
                return "Now"
            } else if hoursLeft > 0 {
                return "Today"
            }
            return "\(abs(hoursLeft)) hours ago"
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
        return interval(component: .day)
    }

    private var hoursLeft: Int {
        return interval(component: .hour)
    }

    private func interval(component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        guard let start = calendar.ordinality(of: component, in: .era, for: Date()),
            let end = calendar.ordinality(of: component, in: .era, for: task.finishDate) else {
                return 0
        }

        return end - start
    }
}

extension TaskViewModel: Differentiable {
    var differenceIdentifier: String {
        return task.id
    }
    
    func isContentEqual(to source: TaskViewModel) -> Bool {
        return self == source
    }
}

extension TaskViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(task.id)
        hasher.combine(task.period.rawValue)
        hasher.combine(task.title)
        hasher.combine(color.value)
    }

    static func ==(lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.task == rhs.task && lhs.color.value == rhs.color.value
    }
}
