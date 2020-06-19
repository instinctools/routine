//
//  Task.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

extension Optional where Wrapped == Task.ResetType {
    var orDefault: Task.ResetType {
        return self ?? .byPeriod
    }
}

struct Task: Equatable {
    
    enum ResetType: String {
        case byPeriod = "BY_PERIOD"
        case byDate = "BY_DATE"
        
        var index: Int {
            switch self {
            case .byPeriod:
                return 0
            case .byDate:
                return 1
            }
        }
        
        init(indexValue: Int) {
            switch indexValue {
            case 0:
                self = .byPeriod
            default:
                self = .byDate
            }
        }
    }
    
    let id: String
    let title: String
    let period: Period
    let periodCount: Int
    let startDate: Date
    let resetType: ResetType
    
    var finishDate: Date {
        return Calendar.current.date(
            byAdding: period.calendarComponent,
            value: periodCount,
            to: startDate
        ).orToday
    }
    
    init(id: String, title: String, period: Period, periodCount: Int, startDate: Date, resetType: ResetType) {
        self.id = id
        self.title = title
        self.period = period
        self.periodCount = periodCount
        self.startDate = startDate
        self.resetType = resetType
    }
    
    init(entity: TaskEntity) {
        self.id = entity.id.orEmpty
        self.title = entity.title.orEmpty
        self.period = Period(rawValue: entity.period.orEmpty).orDefault
        self.periodCount = Int(entity.periodCount)
        self.startDate = entity.startDate.orToday
        self.resetType = ResetType(rawValue: entity.resetType.orEmpty).orDefault
    }
}
