//
//  RoutineApp.swift
//  WatchRoutine Extension
//
//  Created by Vadim Koronchik on 11.08.21.
//

import SwiftUI
import UserNotifications
import Combine

protocol FactoryProtocol {
    func makeTaskListViewModel() -> TaskListViewModel
}

@main
struct RoutineApp: App {
    
    private let factory = Factory()
    
    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.factory, factory)
                .environmentObject(factory.makeTaskListViewModel())
        }
    }
}
