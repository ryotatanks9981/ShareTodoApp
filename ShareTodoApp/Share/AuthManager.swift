import Foundation
import FirebaseAuth

protocol AuthProtocol {
    func signIn(email: String, passowrd: String, completion: @escaping () -> Void)
    func createAccount(email: String, passowrd: String, completion: @escaping (User) -> Void)
    func signOut() throws -> Void
    func deleteAccount()
}

class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
}

extension AuthManager: AuthProtocol {
    func signIn(email: String, passowrd: String, completion: @escaping () -> Void) {
        auth.signIn(withEmail: email, password: passowrd) { (_, error) in
            guard error == nil else { return }
            completion()
        }
    }
    
    func createAccount(email: String, passowrd: String, completion: @escaping (User) -> Void) {
        auth.createUser(withEmail: email, password: passowrd) { (result, error) in
            guard let user = result?.user, error == nil else { return }
            user.sendEmailVerification { (error) in
                guard error == nil else { return }
                completion(user)
            }
        }
    }
    
    func signOut() throws {
        
    }
    
    func deleteAccount() {
        
    }
}
