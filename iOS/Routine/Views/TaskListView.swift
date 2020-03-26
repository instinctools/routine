//
//  TaskListView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
    
    @State private var tasks: [Task] = [
        Task.mock,
        Task.mock2
    ]
    
    var body: some View {
        List {
            ForEach(tasks, id: \.title) { task in
                TaskRowView(task: task)
                    .frame(height: 44)
                    .padding()
            }
            .onDelete(perform: delete)
        }.animation(.default)
//        TableView(
//            data: tasks,
//            content: { (task) in
//                TaskRowView(task: task)
//            }
//        )
    }
    
    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
