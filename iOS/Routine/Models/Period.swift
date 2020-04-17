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
    
    var title: String {
        let period: String
        switch self {
        case .day:
            period = "day"
        case .week:
            period = "week"
        case .month:
            period = "month"
        case .year:
            period = "year"
        }
        return "Every \(period)"
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
        
    func calculateDate(withStardDate startDate: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: calendarComponent, value: 1, to: startDate)!
    }
}
