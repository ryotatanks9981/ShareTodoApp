import Foundation

struct TodoModel {
    let id: String
    let isImportant: Bool
    let title: String
    let detail: String
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        isImportant = data["isImportant"] as? Bool ?? false
        title = data["title"] as? String ?? ""
        detail = data["detail"] as? String ?? ""
    }
}
