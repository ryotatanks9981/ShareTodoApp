class BaseCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    
    func start() {
        fatalError("children should implement 'start' function.")
    }
}
