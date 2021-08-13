//
//  CoreDataManager.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/6/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "Routine")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let error = error else { return }
            assertionFailure("\(#function): Failed to load persistent stores: \(error)")
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
}
