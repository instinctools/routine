//
//  Period.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/26/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation

enum Period: Int, CaseIterable {
    case day
    case week
    case month
    case year
    
    func fullTitle(periodCount: Int) -> String {
        let prefix = periodCount > 1 ? "\(periodCount) " : ""
        return prefix + title(periodCount: periodCount)
    }
    
    func title(periodCount: Int) -> String {
        let hasPeriod = periodCount > 1
        switch self {
        case .day:
            return hasPeriod ? "days" : "day"
        case .week:
            return hasPeriod ? "weeks" : "week"
        case .month:
            return hasPeriod ? "monthes" : "month"
        case .year:
            return hasPeriod ? "years" : "year"
        }
    }
        
    private var calendarComponent: Calendar.Component {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekOfMonth
        case .month:
            return .month
        case .year:
            return .year
        }
    }
        
    func calculateDate(withStardDate startDate: Date, periodCount: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: calendarComponent, value: periodCount, to: startDate).orToday
    }
}

extension Optional where Wrapped == Period {
    var orDefault: Period {
        return self ?? .day
    }
}
