import Foundation
import RoutineShared

extension PeriodUnit {
    
    func title(count: Int? = nil) -> String {
        let countOrZero = count ?? 0
        let hasPeriod = countOrZero > 1
        switch self {
            case .day:
                return hasPeriod ? "\(countOrZero) Days" : "Day"
            case .week:
                return hasPeriod ? "\(countOrZero) Weeks" : "Week"
            case .month:
                return hasPeriod ? "\(countOrZero) Months" : "Month"
            case .year:
                return hasPeriod ? "\(countOrZero) Years" : "Year"
            default:
                return "Unknwon"
        }
    }
}
