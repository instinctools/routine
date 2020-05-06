//
//  CoreDataManager.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/6/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static var shared = CoreDataManager()
     
    private(set) lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Routine")
         
        let description = container.persistentStoreDescriptions.first
        description?.setOption(NSNumber(value: true), forKey: NSPersistentHistoryTrackingKey)
        description?.setOption(NSNumber(value: true), forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let error = error as NSError? else { return }
            assertionFailure("\(#function): Failed to load persistent stores: \(error)")
        })
         
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(storeRemoteChange(_:)),
//            name: .NSPersistentStoreRemoteChange,
//            object: nil
//        )
         
        return container
    }()
     
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
     
    private var historyLastToken: NSPersistentHistoryToken? = nil {
        didSet {
            guard let token = historyLastToken,
                let data = try? NSKeyedArchiver.archivedData(
                    withRootObject: token,
                    requiringSecureCoding: true
                ) else { return }
             
            do {
                try data.write(to: historyTokenFile)
            } catch {
                assertionFailure("\(#function): Could not write token data: \(error)")
            }
        }
    }
     
    private var historyTokenFile: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("Routine", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(
                    at: url,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                assertionFailure("\(#function): Could not create persistent container URL: \(error)")
            }
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
     
    private init() {
        deleteHistoryIfNeeded()
    }

    @objc private func storeRemoteChange(_ notification: Notification) {
        historyQueue.addOperation(processPersistentHistory)
    }
     
    private func deleteHistoryIfNeeded() {
        let sevenDaysAgo = Date(timeIntervalSinceNow: Double(-604800))
        let purgeHistoryRequest = NSPersistentHistoryChangeRequest.deleteHistory(before: sevenDaysAgo)
        do {
            try persistentContainer.newBackgroundContext().execute(purgeHistoryRequest)
        } catch {
            fatalError("Could not purge history: \(error)")
        }
    }
     
    private func processPersistentHistory() {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {
            let fetchHistoryRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.historyLastToken)
            
            guard let historyResult = try? taskContext.execute(fetchHistoryRequest) as? NSPersistentHistoryResult,
                let history = historyResult.result as? [NSPersistentHistoryTransaction] else {
                    assertionFailure("Could not convert history result to transactions.")
                    return
            }
             
            var filteredTransactions = [NSPersistentHistoryTransaction]()
            for transaction in history.reversed() {
                let filteredChanges = transaction.changes?.filter { change -> Bool in
                    return TaskEntity.entity().name == change.changedObjectID.entity.name
                } ?? []
                if !filteredChanges.isEmpty {
                    filteredTransactions.append(transaction)
                }
                self.historyLastToken = transaction.token
            }
            if filteredTransactions.isEmpty { return }
        }
    }
}
