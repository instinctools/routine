//
//  Period.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/26/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation

enum Period: String, CaseIterable {
    case day = "day"
    case week = "week"
    case month = "month"
    case year = "year"
    
    var title: String {
        return "Every \(self.rawValue)"
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
