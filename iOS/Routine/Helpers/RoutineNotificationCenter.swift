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
    private let taskProvider: TaskProvider
    
    private var backgroundResponseCompletion: (() -> Void)?
    
    override init() {
        let container = CoreDataManager.shared.persistentContainer
        self.taskProvider = TaskProvider(persistentContainer: container)
        super.init()
        notificationCenter.delegate = self
        taskProvider.fetchedResultsControllerDelegate = self
    }
    
    private func updateScheduledNotificationsBadgeValues() {
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
            guard error == nil else { return }
            self.updateScheduledNotificationsBadgeValues()
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
        
        
        updateScheduledNotificationsBadgeValues()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let requestId = response.notification.request.identifier
        let categoryId = response.notification.request.content.categoryIdentifier
        
        if categoryId == UserNotificationCategoryType.task.rawValue,
            let action = TaskCategoryAction(rawValue: response.actionIdentifier) {
            
            UIApplication.shared.applicationIconBadgeNumber -= 1
            
            self.backgroundResponseCompletion = completionHandler
            
            switch action {
            case .reset:
                taskProvider.resetTask(id: requestId)
            case .delete:
                taskProvider.deleteTask(byId: requestId)
            }
        }        
    }
}

extension RoutineNotificationCenter: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let entity = anObject as? TaskEntity else { return }
        
        let task = Task(entity: entity)
        switch type {
        case .delete:
            self.removeNotification(withId: task.id)
        default:
            self.addNotification(forTask: task)
        }
        
        backgroundResponseCompletion?()
    }
}

// Task notifications setup
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
