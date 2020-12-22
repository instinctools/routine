import Foundation
import RoutineShared
import FirebaseAuth

class FirebaseAuthInteractor: IoFirebaseAuthInteractor {
    
    func getUserId(listener: @escaping (String?) -> Void) {
        let userId = Auth.auth().currentUser?.uid
        listener(userId)
    }
    
    func login(listener: @escaping (String?, KotlinException?) -> Void) {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                listener(nil, KotlinException(message: error.localizedDescription))
            } else if let user = authResult?.user {
                listener(user.uid, nil)
            } else {
                listener(nil, UnauthorizedFirebaseError())
            }
        }
    }
    
    func logout(listener: @escaping (KotlinException?) -> Void) {
        do {
            try Auth.auth().signOut()
            listener(nil)
        } catch {
            listener(KotlinException(message: error.localizedDescription))
        }
    }
}
