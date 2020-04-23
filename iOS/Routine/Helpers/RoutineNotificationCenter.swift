//
//  TaskNotificationCenter.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 4/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

protocol TasksNotificationCenter {
    func addNotification(forTask task: Task)
    func removeNotification(withId id: String)
}

extension Notification.Name {
    static let onTaskUpdate = Notification.Name("onTaskUpdate")
}

enum UserNotificationCategoryType: String {
    case task
}

enum TaskCategoryAction: String {
    case reset
    case delete
}

final class RoutineNotificationCenter: NSObject {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    private func updateScheduledNotificationsBadgeValues() {
        notificationCenter.getPendingNotificationRequests { (requests) in
            let sortedRequests = requests.sorted {
                let firstTrigger = ($0.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() ?? .init()
                let secondTrigger = ($1.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() ?? .init()
                return firstTrigger < secondTrigger
            }
            
            for i in 0..<sortedRequests.count {
                let request = sortedRequests[i]
                
                guard let content = request.content.mutableCopy() as? UNMutableNotificationContent else {
                    continue
                }
                
                content.badge = (i + 1) as NSNumber
                let newRequest = UNNotificationRequest(
                    identifier: request.identifier,
                    content: content,
                    trigger: request.trigger
                )
                self.notificationCenter.add(newRequest, withCompletionHandler: nil)
            }
        }
    }
    
    func requestNotifications() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (_, _) in }
    }
    
    func addScheduledNotification(content: UNNotificationContent, id: String, nextDate: Date) {
        let dateMatching = Calendar.current.dateComponents(
            [.second, .minute, .hour, .day, .month, .year],
            from: nextDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if error == nil {
                self.updateScheduledNotificationsBadgeValues()
            }
        }
    }
    
    func removeNotification(withId id: String) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        updateScheduledNotificationsBadgeValues()
    }
    
    func removeAllDeliveredNotifications() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationCenter.removeAllDeliveredNotifications()
        updateScheduledNotificationsBadgeValues()
    }
}

extension RoutineNotificationCenter: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        NotificationCenter.default.post(name: .onTaskUpdate, object: nil)
        
        updateScheduledNotificationsBadgeValues()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        defer {
            completionHandler()
        }
        
        guard let requestId = UUID(uuidString: response.notification.request.identifier) else { return }
        let categoryId = response.notification.request.content.categoryIdentifier
        
        if categoryId == UserNotificationCategoryType.task.rawValue,
            let action = TaskCategoryAction(rawValue: response.actionIdentifier) {
            
            UIApplication.shared.applicationIconBadgeNumber -= 1
            
            switch action {
            case .reset:
                guard let task = TasksRepository.shared.resetTask(id: requestId) else { return }
                addNotification(forTask: task)
            case .delete:
                TasksRepository.shared.deleteTask(byId: requestId)
                removeNotification(withId: requestId.uuidString)
            }
        }
        
        NotificationCenter.default.post(name: .onTaskUpdate, object: nil)
    }
}

extension RoutineNotificationCenter: TasksNotificationCenter {
    func addNotification(forTask task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = "Your task is expired. Please go to the application to reset or delete your task."
        content.categoryIdentifier = UserNotificationCategoryType.task.rawValue
        content.sound = UNNotificationSound.default
        addScheduledNotification(content: content, id: task.id.uuidString, nextDate: task.finishDate)
    }
    
    func registerTaskCategory() {
        let resetAction = UNNotificationAction(
            identifier: TaskCategoryAction.reset.rawValue,
            title: "Reset",
            options: [])
        let deleteAction = UNNotificationAction(
            identifier: TaskCategoryAction.delete.rawValue,
            title: "Delete this task forever",
            options: [.destructive]
        )
        
        let category = UNNotificationCategory(
            identifier: UserNotificationCategoryType.task.rawValue,
            actions: [resetAction, deleteAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: nil,
            categorySummaryFormat: nil,
            options: [
                
            ]
        )
        notificationCenter.setNotificationCategories([category])
    }
}
