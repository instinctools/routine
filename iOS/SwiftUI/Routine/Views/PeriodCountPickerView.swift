//
//  PeriodCountPickerView.swift
//  PeriodCountPickerView
//
//  Created by Vadim Koronchik on 2.08.21.
//

import SwiftUI

struct PeriodCountPickerView: View {
    
    @State var selectedCount: Int
    
    var action: (Int) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Choose period")
                    .foregroundColor(.gray)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Button {
                    action(selectedCount)
                } label: {
                    Text("Done")
                        .foregroundColor(.primary)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            
            Divider()
            
            Picker(selection: $selectedCount) {
                ForEach(1..<61) { count in
                    Text(String(count)).tag(count)
                }
            } label: {
                EmptyView()
            }
            .pickerStyle(.wheel)
        }
        .padding()
    }
}

struct PeriodCountPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodCountPickerView(selectedCount: 10) { count in
            
        }
    }
}
