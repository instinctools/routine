//
//  PeriodView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI

typealias EmptyAction = () -> Void

struct PeriodView: View {
    
    var period: String
    var onSelect: EmptyAction
    
    @State private var selected = false
    
    var body: some View {
        HStack {
            Text(period)
                .font(Font.system(size: 24, weight: .medium))
                .foregroundColor(selected ? Color.white : Color.gray)
            Spacer()
            Circle()
                .frame(width: 10)
                .foregroundColor(selected ? Color.white : Color.gray)
        }
        .background(selected ? Color.gray : .init(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .onTapGesture {
            self.selected.toggle()
            self.onSelect()
        }
    }
}

struct PeriodView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodView(period: "Every year", onSelect: {}).frame(height: 44).padding()
    }
}
