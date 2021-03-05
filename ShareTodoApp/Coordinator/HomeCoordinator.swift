import UIKit

class HomeCoordinator: BaseCoordinator {
    var navVC: UINavigationController
    private let storeManager = StoreUserManager.shared
    
    init(navVC: UINavigationController) {
        self.navVC = navVC
    }
    
    override func start() {
        let vc = HomeViewController.instantiate()
        vc.viewModelBuilder = { [storeManager] in
            let viewModel = HomeViewModel(input: $0, storeManager: storeManager)
            return viewModel
        }
        navVC.pushViewController(vc, animated: true)
    }
}
