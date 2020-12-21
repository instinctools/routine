import Foundation
import Firebase
import RoutineShared

class FirebaseInteractor : IosFirestoreInteractor {

    lazy var firestore = Firestore.firestore()
    lazy var auth = Auth.auth()
    
    func fetchTodos(userId: String, listener: @escaping ([Todo]?, KotlinException?) -> Void) {
        todosCollection(userId: userId).getDocuments() { (querySnapshot, error) in
            if let error = error {
                listener(nil, KotlinException(message: error.localizedDescription))
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                listener([], nil)
            }
        }
    }

    func addTodo(userId: String, todo: Todo, listener: @escaping (String?, KotlinException?) -> Void) {
         todosCollection(userId: userId).addDocument(data: todo.toFirebaseMap()) { error in
            if let error = error {
                listener(nil, KotlinException(message: error.localizedDescription))
            } else {
                listener("", nil)
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
    
    func obtainUserId(listener: @escaping (String?, KotlinException?) -> Void) {
        if let user = Auth.auth().currentUser {
            listener(user.uid, nil)
        } else {
            auth.signInAnonymously { (authResult, error) in
                if let error = error {
                    listener(nil, KotlinException(message: error.localizedDescription))
                } else if let user = authResult?.user {
                    listener(user.uid, nil)
                }
            }
        }
    }
    
    private func todosCollection(userId: String) -> CollectionReference {
        return firestore.collection(FirebaseConst.Collection().users)
            .document(userId)
            .collection(FirebaseConst.Collection().todos)
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
