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
    
    func title(periodCount: Int) -> String {
        let hasPeriod = periodCount > 1
        switch self {
        case .day:
            return hasPeriod ? "\(periodCount) days" : "day"
        case .week:
            return hasPeriod ? "\(periodCount) weeks" : "week"
        case .month:
            return hasPeriod ? "\(periodCount) monthes" : "month"
        case .year:
            return (hasPeriod ? "\(periodCount) years" : "year")
        }
    }
        
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
