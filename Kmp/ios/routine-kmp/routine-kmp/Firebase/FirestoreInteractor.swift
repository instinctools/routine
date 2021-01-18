import Foundation
import Firebase
import RoutineShared

class FirestoreInteractor : IosFirestoreInteractor {

    lazy var firestore = Firestore.firestore()
    lazy var auth = Auth.auth()
    
    func fetchTodos(userId: String, listener: @escaping ([Todo]?, KotlinException?) -> Void) {
        todosCollection(userId: userId).getDocuments() { (querySnapshot, error) in
            if let error = error {
                listener(nil, KotlinException(message: error.localizedDescription))
            } else {
                var todos = [Todo]()
                for document in querySnapshot!.documents {
                    todos.append(self.todoFrom(document: document))
                }
                listener(todos, nil)
            }
        }
    }

    func addTodo(userId: String, todo: Todo, listener: @escaping (String?, KotlinException?) -> Void) {
        let document = todosCollection(userId: userId).document()
        document.setData(todo.toFirebaseMap()) { error in
            if let error = error {
                listener(nil, KotlinException(message: error.localizedDescription))
            } else {
                listener(document.documentID, nil)
            }
        }
    }
    
    func deleteTodo(userId: String, todoId: String, listener: @escaping (KotlinException?) -> Void) {
        todosCollection(userId: userId).document(todoId).delete() { error in
            if let error = error {
                listener(KotlinException(message: error.localizedDescription))
            } else {
                listener(nil)
            }
        }
    }
    
    func updateTodo(userId: String, todo: Todo, listener: @escaping (KotlinException?) -> Void) {
        todosCollection(userId: userId).document(todo.id).setData(todo.toFirebaseMap()) { error in
            if let error = error {
                listener(KotlinException(message: error.localizedDescription))
            } else {
                listener(nil)
            }
        }
    }
    
    private func todosCollection(userId: String) -> CollectionReference {
        return firestore.collection(FirebaseConst.Collection().users)
            .document(userId)
            .collection(FirebaseConst.Collection().todos)
    }
    
    func todoFrom(document: QueryDocumentSnapshot) -> Todo {
        let consts =  FirebaseConst.Todo()
        
        let periodUnitId = document.get(consts.FIELD_PERIOD_UNIT) as! String
        let periodUnit = PeriodUnit.Companion().find(id: periodUnitId)
        
        let resetStrategyId = document.get(consts.FIELD_PERIOD_STRATEGY) as! String
        let resetStrategy = PeriodResetStrategy.Companion().find(id: resetStrategyId)
        
        let nextTimestamp = document.get(consts.FIELD_TIMESTAMP) as! Timestamp
        let nextDate = DatesKt.dateFromEpoch(timestamp: nextTimestamp.seconds)

        return Todo(
            id: document.documentID,
            title: document.get(consts.FIELD_TITLE) as! String,
            periodUnit: periodUnit,
            periodValue: document.get(consts.FIELD_PERIOD_VALUE) as! Int32,
            periodStrategy: resetStrategy,
            nextDate: nextDate
        )
    }
}

extension Todo {
    func toFirebaseMap() -> [String : Any] {
        let consts =  FirebaseConst.Todo()
        let timestamp = Double(self.nextDate.timestampSystemTimeZone)
        return [
            consts.FIELD_TITLE : self.title,
            consts.FIELD_PERIOD_UNIT : self.periodUnit.id,
            consts.FIELD_PERIOD_VALUE : self.periodValue,
            consts.FIELD_PERIOD_STRATEGY : self.periodStrategy.id,
            consts.FIELD_TIMESTAMP : Timestamp(date: Date(timeIntervalSince1970: timestamp))
        ]
    }
}
