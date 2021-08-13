//
//  TaskNotificationCenter.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 4/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import UserNotifications

enum UserNotificationCategoryType: String {
    case task
}

enum TaskCategoryAction: String {
    case reset
    case delete
}

final class RoutineNotificationCenter: NSObject {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private lazy var taskProvider: TaskProvider = FirebaseTaskProvider()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    private func updateScheduledNotificationsBadgeValues(currentBadge: Int) {
        notificationCenter.getPendingNotificationRequests { (requests) in
            let sortedRequests = requests
                .filter { $0.trigger is UNCalendarNotificationTrigger }
                .sorted {
                    let firstTriggerDate = (($0.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()).orToday
                    let secondTriggerDate = (($1.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()).orToday
                    return firstTriggerDate < secondTriggerDate
                }
            
            for i in 0..<sortedRequests.count {
                let request = sortedRequests[i]
                
                guard let content = request.content.mutableCopy() as? UNMutableNotificationContent else {
                    continue
                }
                
                content.badge = (currentBadge + i + 1) as NSNumber
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
        
        notificationCenter.add(request)
    }
    
    func refreshNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
        taskProvider.getAllTasks { [weak self] (tasks) in
            guard let `self` = self else { return }
            tasks.forEach(self.addNotification(forTask:))
            self.updateScheduledNotificationsBadgeValues(currentBadge: 0)
        }
    }
    
    func removeAllDeliveredNotifications() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationCenter.removeAllDeliveredNotifications()
        updateScheduledNotificationsBadgeValues(currentBadge: 0)
    }

    private func removeNotification(withId id: String) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
}

extension RoutineNotificationCenter: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let requestId = response.notification.request.identifier
        let categoryId = response.notification.request.content.categoryIdentifier
        
        if categoryId == UserNotificationCategoryType.task.rawValue,
            let action = TaskCategoryAction(rawValue: response.actionIdentifier) {
            
            UIApplication.shared.applicationIconBadgeNumber -= 1
            
            switch action {
            case .reset:
                taskProvider.resetTask(id: requestId, completion: { task in
                    if let task = task {
                        self.addNotification(forTask: task)
                        self.updateScheduledNotificationsBadgeValues(currentBadge: UIApplication.shared.applicationIconBadgeNumber)
                    }
                    completionHandler()
                })
            case .delete:
                taskProvider.deleteTask(byId: requestId)
                removeNotification(withId: requestId)
                updateScheduledNotificationsBadgeValues(currentBadge: UIApplication.shared.applicationIconBadgeNumber)
                completionHandler()
            }
        }        
    }
}

extension RoutineNotificationCenter {
    func addNotification(forTask task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = "Your task is expired. Please go to the application to reset or delete your task."
        content.categoryIdentifier = UserNotificationCategoryType.task.rawValue
        content.sound = UNNotificationSound.default
        addScheduledNotification(content: content, id: task.id, nextDate: task.finishDate)
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
