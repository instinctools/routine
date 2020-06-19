//
//  FirebaseTaskProvider.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/19/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

private struct FirebaseTask: Codable {
    let id: String
    let period: Int
    let periodUnit: String
    let timestamp: Timestamp
    let title: String
    let resetType: String
    
    init(task: Task) {
        self.id = task.id
        self.period = task.periodCount
        self.periodUnit = task.period.rawValue
        self.timestamp = Timestamp(date: task.startDate)
        self.title = task.title
        self.resetType = task.resetType.rawValue
    }
    
    var task: Task {
        let unit = Period(rawValue: periodUnit).orDefault
        let resetType = Task.ResetType(rawValue: self.resetType).orDefault
        return Task(id: id,
                    title: title,
                    period: unit,
                    periodCount: period,
                    startDate: timestamp.dateValue(),
                    resetType: resetType)
    }
}

private struct FirestoreDBKeys {
    static let users = "users"
    static let tasks = "todos"
}

final class FirebaseTaskProvider: TaskProvider {
    
    let db = Firestore.firestore()
    
    private lazy var tasksReference: CollectionReference? = {
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        return db.collection(FirestoreDBKeys.users).document(userId).collection(FirestoreDBKeys.tasks)
    }()
    
    func getAllTasks(completion: @escaping ([Task]) -> Void) {
        guard let tasksRef = tasksReference else {
            completion([])
            return
        }
        
        tasksRef.getDocuments(source: .cache) { [weak self] (snapshot, error) in
            if let error = error {
                self?.log(error: error)
                completion([])
                return
            }
            
            let tasks = snapshot?.documents.compactMap{ try? $0.data(as: FirebaseTask.self)?.task } ?? []
            completion(tasks)
        }
    }
    
    func add(task: Task) {
        guard let tasksRef = tasksReference else { return }
        
        let firTask = FirebaseTask(task: task)
        do {
            _ = try tasksRef.document(firTask.id).setData(from: firTask)
        } catch {
            log(error: error)
        }
    }
    
    func resetTask(id: String, completion: ((Task?) -> Void)?) {
        guard let tasksRef = tasksReference else { return }
        
        tasksRef.document(id).getDocument(source: .cache) { [weak self] (snapshot, error) in
            if let error = error {
                self?.log(error: error)
                completion?(nil)
            } else if let task = try? snapshot?.data(as: FirebaseTask.self)?.task {
                let resetedTask = TaskUtility.reset(task: task)
                self?.update(task: resetedTask)
                completion?(resetedTask)
            } else {
                completion?(nil)
            }
        }
    }
    
    func update(task: Task) {
        add(task: task)
    }
    
    func deleteTask(byId id: String) {
        guard let tasksRef = tasksReference else { return }
        
        tasksRef.document(id).delete { [weak self] (error) in
            if let error = error {
                self?.log(error: error)
            }
        }
    }
        
    private func log(error: Error) {
        assertionFailure(error.localizedDescription)
    }
}
