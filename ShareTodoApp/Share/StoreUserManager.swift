import Foundation
import FirebaseFirestore
import Firebase

protocol StoreUserProtocol {
    func createNewAccount(user: User, completion: @escaping () -> Void)
}

class StoreUserManager {
    
    static let shared = StoreUserManager()
    private let store = Firestore.firestore()
    
}

extension StoreUserManager: StoreUserProtocol {
    func createNewAccount(user: User, completion: @escaping () -> Void) {
        let data: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "createdAt": Timestamp()
        ]
        store.collection("users").document(user.uid).setData(data) { error in
            guard error == nil else { return }
            completion()
        }
    }
}
