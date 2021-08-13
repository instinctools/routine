//
//  Period.swift
//  Period
//
//  Created by Vadim Koronchik on 29.07.21.
//

import Foundation

enum Period: String, CaseIterable {
    case day = "DAY"
    case week = "WEEK"
    case month = "MONTH"
    case year = "YEAR"
        
    var calendarComponent: Calendar.Component {
        switch self {
        case .day:
            return .minute
        case .week:
            return .weekOfMonth
        case .month:
            return .month
        case .year:
            return .year
        }
    }
}
