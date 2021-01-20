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

extension Todo {
    func periodFriendlyTitle() -> String {
        let oneInterval = periodValue == 1
        switch periodUnit {
        case .day:
            return oneInterval ? "Every day" : "Every \(periodValue) days"
        case .week:
            return oneInterval ? "Once a week" : "Every \(periodValue) weeks"
        case .month:
            return oneInterval ? "Once a month" : "Every \(periodValue) months"
        case .year:
            return oneInterval ? "Once a year" : "Every \(periodValue) years"
        default:
            return "Unknwon period"
        }
    }
}

extension TodoListUiModel {
    func daysLeftTitle() -> String {
        switch Int(daysLeft) {
        case -1: return "Yesterday"
        case -6 ... -1: return "\(abs(daysLeft)) days ago"
        case -7: return "1 week ago"
        case Int.min ... -7: return "Expired"
            
        case 0: return "Today"
        case 1: return "Tomorrow"
        case 2 ... 6: return "\(daysLeft) days left"
        case 7: return "1 week left"
        default: return "More than 1 week"
        }
    }
}
