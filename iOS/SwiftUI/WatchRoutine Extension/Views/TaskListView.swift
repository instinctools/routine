//
//  TaskLitView.swift
//  WatchRoutine Extension
//
//  Created by Vadim Koronchik on 11.08.21.
//

import SwiftUI
import Combine

enum TaskListModel: Identifiable {
    case item(TaskRowModel)
    case divider
    
    var id: String? {
        switch self {
        case .item(let taskRowModel): return taskRowModel.task.id
        case .divider: return nil
        }
    }
}

struct TaskListView: View {
    
    @EnvironmentObject private var viewModel: TaskListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                switch item {
                case .divider:
                    Divider()
                        .listRowBackground(Color.clear)
                case .item(let model):
                    TaskRowView(model: model)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .placeholder(viewModel.items) {
                Image("placeholder")
                    .resizable()
            }
            .listStyle(.plain)
            .navigationTitle("Routine")
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
