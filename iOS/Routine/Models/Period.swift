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
    
    func fullTitle(periodCount: Int?) -> String {
        let count = periodCount ?? 0
        let hasPeriod = count > 1
        switch self {
        case .day:
            return hasPeriod ? "\(count) days" : "day"
        case .week:
            return hasPeriod ? "\(count) weeks" : "week"
        case .month:
            return hasPeriod ? "\(count) monthes" : "month"
        case .year:
            return hasPeriod ? "\(count) years" : "year"
        }
    }
    
    func title(periodCount: Int?) -> String {
        let count = periodCount ?? 0
        let hasPeriod = count > 1
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
        
    func calculateDate(withStardDate startDate: Date, periodCount: Int?) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: calendarComponent, value: periodCount ?? 1, to: startDate)!
    }
}
