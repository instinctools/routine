//
//  TaskRowView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI

struct TaskRowView: View {
    
    var viewModel: TaskViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .font(Font.system(size: 19, weight: .semibold))
                    .foregroundColor(Color.white)
                Spacer()
            }
            .padding(.bottom, 8)
            
            HStack {
                Text(viewModel.period)
                    .font(Font.system(size: 14, weight: .medium))
                    .foregroundColor(Color.white)
                Spacer()
                Text(viewModel.timeLeft)
                    .font(Font.system(size: 14, weight: .medium))
                    .foregroundColor(Color.white)
            }
        }
        .padding(.all, 14)
        .background(Color(viewModel.color))
        .cornerRadius(12)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(viewModel: TaskViewModel(task: .mock, color: .red))
    }
}
