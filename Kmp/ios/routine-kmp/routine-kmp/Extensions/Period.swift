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
    
    func title(count: Int?) -> String {
        let hasPeriod = (count ?? 0) > 1
        switch self {
            case .day:
                return hasPeriod ? "days" : "day"
            case .week:
                return hasPeriod ? "weeks" : "week"
            case .month:
                return hasPeriod ? "monthes" : "month"
            case .year:
                return hasPeriod ? "years" : "year"
            default:
                return " unknwon"
        }
    }
}
