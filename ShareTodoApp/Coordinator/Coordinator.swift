import Foundation

protocol Coordinator: class {
    var childCoordinator: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func add(_ coordinator: Coordinator) {
        childCoordinator.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        childCoordinator = childCoordinator.filter { $0 !== coordinator }
    }
}
