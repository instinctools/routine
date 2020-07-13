import Foundation
import RoutineShared

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
