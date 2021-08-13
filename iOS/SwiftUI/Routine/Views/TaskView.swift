//
//  TaskView.swift
//  TaskView
//
//  Created by Vadim Koronchik on 29.07.21.
//

import SwiftUI

struct TaskView: View {
    
    @State private var countPickerPresented = false
    @EnvironmentObject private var viewModel: TaskViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                MultilineTextField(text: $viewModel.title,
                                   placeholder: "Type recurring task name...",
                                   font: .systemFont(ofSize: 24))
                
                Picker(selection: $viewModel.resetType) {
                    ForEach(Task.ResetType.allCases, id: \.rawValue) { resetType in
                        Text(resetType.displayTitle).tag(resetType)
                    }
                } label: {
                    EmptyView()
                }
                .pickerStyle(.segmented)
                
                HStack {
                    VStack { Divider().background(.secondary) }.frame(width: 24)
                    Text("Repeat every").padding(.all, 10).foregroundColor(.secondary)
                    VStack { Divider().background(.secondary) }
                }
                
                ForEach(viewModel.periods.indices) { index in
                    PeriodView(
                        isSelected: viewModel.isSelected(at: index),
                        viewModel: viewModel.period(at: index)
                    ) {
                        viewModel.selectPeriod(at: index)
                    } periodCountAction: {
                        viewModel.selectPeriod(at: index)
                        withAnimation { countPickerPresented = true }
                    }
                }
                
                Spacer()
                    .layoutPriority(1)
            }
            .padding(.bottom)
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.primary)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.saveTask()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                            .fontWeight(.medium)
                    }
                    .disabled(!viewModel.isValid)
                    .buttonStyle(
                        EnabledButtonStyle(enabledColor: .primary,
                                           disabledColor: .secondary)
                    )
                }
            }
            .bottomSheet(isPresented: $countPickerPresented) {
                PeriodCountPickerView(
                    selectedCount: viewModel.selectedPeriod.periodCount) { count in
                        viewModel.updatePeriodCount(count)
                        withAnimation { countPickerPresented = false }
                    }
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
            .environmentObject(MockFactory().makeTaskViewModel(taskAction: .edit(.mock)))
            .environment(\.colorScheme, .dark)
    }
}

extension Task.ResetType {
    var displayTitle: String {
        switch self {
        case .byPeriod:
            return "Reset to period"
        case .byDate:
            return "Reset to date"
        }
    }
}
