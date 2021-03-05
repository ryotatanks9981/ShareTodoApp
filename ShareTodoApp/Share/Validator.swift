import Foundation

class Validator {
    static let shared = Validator()
}

extension Validator {
    public func emailValidate(email: String) -> Bool {
        return email.contains("@") && email.contains(".") && !email.isEmpty
    }
    
    public func passwordValidate(passowrd: String) -> Bool {
        return !passowrd.isEmpty && passowrd.count >= 6
    }
}
