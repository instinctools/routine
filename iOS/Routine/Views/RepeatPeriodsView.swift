//
//  RepeatView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/24/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI

struct Period: Identifiable, Equatable {
    let id = UUID()
    let title: String
}

struct RepeatPeriodsView: View {
    
    private var periods = [
        Period(title: "Every day"),
        Period(title: "Every week"),
        Period(title: "Every month"),
        Period(title: "Every year")
    ]
    
    @State private var selectedPeriod: Period?
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            LabelledDivider(label: "Repeat")
            ForEach(periods) { (period) in
                HStack {
                    Text(period.title)
                        .font(Font.system(size: 24, weight: .medium))
                        .foregroundColor(self.isSelected(period: period) ? Color.white : Color.gray)
                        .padding()
                    Spacer()
                    Circle()
                        .frame(width: 12)
                        .foregroundColor(self.isSelected(period: period) ? Color.white : Color.gray)
                        .padding()
                }
                .background(self.isSelected(period: period) ? Color.gray : .init(UIColor.systemGroupedBackground))
                .cornerRadius(12)
                    .frame(height: 44)
                    .padding(.vertical, 8)
                .onTapGesture {
                    self.selectedPeriod = period
                }
            }
            Spacer()
         }
    }
    
    private func isSelected(period: Period) -> Bool {
        return period == selectedPeriod
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatPeriodsView()
    }
}
