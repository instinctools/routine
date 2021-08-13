//
//  RoutineApp.swift
//  Routine
//
//  Created by Vadim Koronchik on 29.07.21.
//

import SwiftUI

protocol FactoryProtocol {
    func makeNotificationService() -> NotificationService
    func makeTaskListViewModel() -> TaskListViewModel
    func makeTaskViewModel(taskAction: TaskAction) -> TaskViewModel
}

@main
struct RoutineApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    private let factory: FactoryProtocol
    private let notificationsService: NotificationService
    
    init() {
        let factory = MockFactory()
        self.factory = factory
        notificationsService = factory.makeNotificationService()
        
        notificationsService.requestNotifications()
        notificationsService.registerTaskCategory()
    }
    
    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.factory, factory)
                .environmentObject(factory.makeTaskListViewModel())
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .background, .inactive:
                notificationsService.refreshNotifications()
            case .active:
                notificationsService.removeAllDeliveredNotifications()
            @unknown default:
                break
            }
        }
    }
}
