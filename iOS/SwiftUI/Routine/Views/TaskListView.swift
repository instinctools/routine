//
//  TaskListView.swift
//  TaskListView
//
//  Created by Vadim Koronchik on 29.07.21.
//

import SwiftUI

enum TaskAction: Identifiable {
    case create
    case edit(Task)
    
    var id: Task? {
        switch self {
        case .create: return nil
        case .edit(let task): return task
        }
    }
}

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
    
    @State private var taskAction: TaskAction?
    @EnvironmentObject private var viewModel: TaskListViewModel
    @Environment(\.factory) private var factory
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    switch item {
                    case .divider:
                        Divider()
                    case .item(let model):
                        Button {
                            self.taskAction = .edit(model.task)
                        } label: {
                            TaskRowView(model: model)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init())
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.resetTask(model)
                            } label: {
                                Text("Reset")
                            }
                        }
                        .tint(Color(
                            .init(red: 222/255,
                                  green: 222/255,
                                  blue: 222/255,
                                  alpha: 1)
                        ))
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.deleteTask(model)
                            } label: {
                                Text("Delete")
                            }
                        }
                        .tint(Color(
                            .init(red: 222/255,
                                  green: 222/255,
                                  blue: 222/255,
                                  alpha: 1)
                        ))
                    }
                }
            }
            .placeholder(viewModel.items) {
                Image("placeholder")
            }
            .environment(\.defaultMinListRowHeight, 0)
            .listStyle(.plain)
            .navigationTitle("Routine")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        taskAction = .create
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    }
                }
            }
            .fullScreenCover(item: $taskAction, content: { item in
                TaskView()
                    .environmentObject(factory.makeTaskViewModel(taskAction: item))
            })
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
