//
//  PeriodView.swift
//  PeriodView
//
//  Created by Vadim Koronchik on 31.07.21.
//

import SwiftUI

struct PeriodView: View {
    
    let isSelected: Bool
    @ObservedObject var viewModel: PeriodViewModel
    
    let action: () -> Void
    let periodCountAction: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Button(action: periodCountAction) {
                    Image("menu")
                        .foregroundColor(
                            isSelected ? Color(UIColor.white) : Color(UIColor.gray)
                        )
                }
                
                Spacer()
                
                Text(title(periodCount: viewModel.periodCount))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(
                        isSelected ? Color(UIColor.white) : Color(UIColor.gray)
                    )
            }
            .padding()
            .background(
                isSelected ? Color(UIColor.gray) : Color(UIColor.secondarySystemBackground)
            )
            .cornerRadius(12)
        } 
    }
    
    private func title(periodCount: Int) -> String {
        let hasPeriodCount = periodCount > 1
        switch viewModel.period {
        case .day:
            return hasPeriodCount ? "\(periodCount) Days" : "Day"
        case .week:
            return hasPeriodCount ? "\(periodCount) Weeks" : "Week"
        case .month:
            return hasPeriodCount ? "\(periodCount) Monthes" : "Month"
        case .year:
            return hasPeriodCount ? "\(periodCount) Years" : "Year"
        }
    }
}

struct PeriodView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodView(
            isSelected: true,
            viewModel: .init(period: .day, periodCount: 1),
            action: {
                
            }, periodCountAction: {
                
            }
        ).frame(height: 50)
    }
}
