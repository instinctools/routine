//
//  TaskRowView.swift
//  SwipeableView
//
//  Created by Vadzim Karonchyk on 5/7/20.
//  Copyright © 2020 koronchik. All rights reserved.
//

import Foundation
import SwiftUI

struct TaskRowView: View {
    
    var viewModel: TaskViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(self.viewModel.title)
                    .font(Font.system(size: 19, weight: .semibold))
                    .foregroundColor(Color.white)
                Spacer()
            }
            .padding(.bottom, 8)

            HStack {
                Text(self.viewModel.period)
                    .font(Font.system(size: 14, weight: .medium))
                    .foregroundColor(Color.white)
                Spacer()
                Text(self.viewModel.timeLeft)
                    .font(Font.system(size: 14, weight: .medium))
                    .foregroundColor(Color.white)
            }
        }
        .padding(.all, 14)
        .background(Color(self.viewModel.color))
        .cornerRadius(12)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(viewModel: .init(task: .mock, color: .red))
    }
}
