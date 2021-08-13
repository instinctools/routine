//
//  TaskRowView.swift
//  TaskRowView
//
//  Created by Vadim Koronchik on 29.07.21.
//

import SwiftUI

struct TaskRowModel {
    let color: Color
    let task: Task
}

struct TaskRowView: View {
    
    let model: TaskRowModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.task.title)
                .foregroundColor(.white)
                .frame(alignment: .leading)
                .font(.system(size: 19, weight: .semibold))
            
            HStack {
                Text(periodTitle())
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text(calculateTimeLeft())
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(model.color)
        .cornerRadius(12)
    }
    
    private func periodTitle() -> String {
        let periodWithCountPrefix: String = {
            if model.task.periodCount > 6 {
                return "Every \(model.task.periodCount)"
            }
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.spellOut
            return "Every " + formatter.string(from: model.task.periodCount as NSNumber).orEmpty
        }()

        let hasPeriodCount = model.task.periodCount > 1
        switch model.task.period {
        case .day:
            return hasPeriodCount ? "\(periodWithCountPrefix) days" : "Every day"
        case .week:
            return hasPeriodCount ? "\(periodWithCountPrefix) weeks" : "Once a week"
        case .month:
            return hasPeriodCount ? "\(periodWithCountPrefix) monthes" : "Once a month"
        case .year:
            return (hasPeriodCount ? "\(periodWithCountPrefix) years" : "Once a year")
        }
    }
    
    private func calculateTimeLeft() -> String {
        let daysLeft = interval(component: .day)
        
        if daysLeft < -30 {
            return "Expired"
        } else if daysLeft < -2 {
            return "\(abs(daysLeft)) days ago"
        } else if daysLeft < 0 {
            return "Yesterday"
        } else if daysLeft == 0 {
            let hoursLeft = interval(component: .hour)
            if hoursLeft == 0 {
                return "Now"
            } else if hoursLeft > 0 {
                return "Today"
            }
            return "\(abs(hoursLeft)) hours ago"
        } else if daysLeft == 1 {
            return "Tomorrow"
        } else if (2..<7).contains(daysLeft) {
            return "\(daysLeft) days left"
        } else if daysLeft == 7 {
            return "1 week left"
        }
        return ""
    }

    private func interval(component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        guard let start = calendar.ordinality(of: component, in: .era, for: Date()),
              let end = calendar.ordinality(of: component, in: .era, for: model.task.finishDate) else {
                return 0
        }
        return end - start
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(model: .init(color: .red, task: .mock))
    }
}
