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
            
            HStack {
                Text(task.period.title)
                    .font(Font.system(size: 14, weight: .light))
                    .foregroundColor(Color.white)
                Spacer()
                Text(task.timeLeft)
                    .font(Font.system(size: 14, weight: .light))
                    .foregroundColor(Color.white)
            }
        }
        .padding(.all, 14)
        .background(Color(task.color))
        .cornerRadius(12)
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: Task.mock)
    }
}
