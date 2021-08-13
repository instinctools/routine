//
//  Period.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/26/20.
//  Copyright © 2020 Instinctools. All rights reserved.
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
            return .day
        case .week:
            return .weekOfMonth
        case .month:
            return .month
        case .year:
            return .year
        }
    }
}

extension Optional where Wrapped == Period {
    var orDefault: Period {
        return self ?? .day
    }
}
