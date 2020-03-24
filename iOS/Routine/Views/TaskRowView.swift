//
//  TaskRowView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI

struct TaskRowView: View {
    
    var task: Task
    
    var body: some View {
        VStack {
            HStack {
                Text(task.title)
                    .font(Font.system(size: 19, weight: .semibold))
                    .foregroundColor(Color.white)
                Spacer()
            }
            .padding(.bottom, 8)
            .padding([.top, .leading, .trailing], 14)
            
            HStack {
                Text(task.repeatPeriod)
                    .font(Font.system(size: 14, weight: .light))
                    .foregroundColor(Color.white)
                Spacer()
                Text(task.executionTime)
                    .font(Font.system(size: 14, weight: .light))
                    .foregroundColor(Color.white)
            }
            .padding([.leading, .trailing, .bottom], 14)
        }
        .background(Color.pink)
        .cornerRadius(12)
        .padding(.vertical, 6)
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: Task.mock)
    }
}
