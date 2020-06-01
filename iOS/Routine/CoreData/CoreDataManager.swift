//
//  CoreDataManager.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/6/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    static var shared = CoreDataManager()
     
    private(set) lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Routine")
        let description = container.persistentStoreDescriptions.first
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let error = error else { return }
            assertionFailure("\(#function): Failed to load persistent stores: \(error)")
        })
         
        return container
    }()
}
