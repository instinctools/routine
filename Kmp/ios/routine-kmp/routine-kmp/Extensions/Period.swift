//
//  Period.swift
//  routine-kmp
//
//  Created by Pavel Horbach on 6/1/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation
import RoutineSharedKmp

extension PeriodUnit {
    
    func title(count: Int? = nil) -> String {
        let hasPeriod = (count ?? 0) > 1
        switch self {
            case .day:
                return hasPeriod ? "Days" : "Day"
            case .week:
                return hasPeriod ? "Weeks" : "Week"
            case .month:
                return hasPeriod ? "Months" : "Month"
            case .year:
                return hasPeriod ? "Years" : "Year"
            default:
                return "Unknwon"
        }
    }
}
