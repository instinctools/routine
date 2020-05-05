//
//  TaskCloudKitRepository.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/4/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation
import CloudKit

final class TaskCloudKitRepository {
    
    private let recordType = "Task"
    private let database = CKContainer.default().privateCloudDatabase
    
    func fetchTassk(completion: @escaping ([CKRecord], Error) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate())
        database.perform(query, inZoneWith: CKRecordZone.default().zoneID) { (records, error) in
            
        }
    }
    
    func addTask(_ task: Task, completionHandler: @escaping (CKRecord?, Error?) -> Void) {
        let record = CKRecord(recordType: recordType, recordID: CKRecord.ID(recordName: task.id))
        record.setValue(task.id, forKeyPath: "id")
        record.setValue(task.title, forKey: "title")
        record.setValue(task.startDate, forKey: "startDate")
        record.setValue(task.period.rawValue, forKey: "period")
        record.setValue((task.periodCount ?? 1), forKey: "periodCount")
        
        database.save(record, completionHandler: completionHandler)
    }
    
    func deleteTask(_ task: Task, completionHandler: @escaping (CKRecord.ID?, Error?) -> Void) {
        database.delete(withRecordID: CKRecord.ID(recordName: task.id), completionHandler: completionHandler)
    }
}
