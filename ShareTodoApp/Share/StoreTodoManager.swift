import Foundation
import FirebaseFirestore
import RxSwift

protocol StoreTodoProtocol {
    func insertTodo(title: String, detail: String, completion: @escaping () -> Void)
    
    func fetchTodosFromFirestore() -> Single<[TodoModel]>
    
    func deleteTodo(todo: TodoModel)
}

class StoreTodoManager: StoreTodoProtocol {
    
    static let shared = StoreTodoManager()
    private let store = Firestore.firestore()
    
    func fetchTodosFromFirestore() -> Single<[TodoModel]> {
        Single.create { [store] (single) -> Disposable in
            store.collection("todos").getDocuments { (snapshots, error) in
                guard let docs = snapshots?.documents, error == nil else {
                    single(.failure(CustomError.error(message: "failed to fetch todos from firestore.")))
                    return
                }
                let todos: [TodoModel] = docs.map({ TodoModel(data: $0.data()) })
                single(.success(todos))
            }
            return Disposables.create {}
        }
    }
    
    func deleteTodo(todo: TodoModel) {
        
    }
    
    func insertTodo(title: String, detail: String, completion: @escaping () -> Void) {
        let uid = UUID().uuidString
        let data: [String: Any] = [
            "title": title,
            "detail": detail,
            "time": Timestamp()
        ]
        store.collection("todos").document(uid).setData(data) { (error) in
            if let err = error {
                print(err)
                return
            } else {
                completion()
            }
        }
    }
    
    
}
