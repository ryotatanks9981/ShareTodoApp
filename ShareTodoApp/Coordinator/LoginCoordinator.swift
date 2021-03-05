import Foundation
import UIKit
import RxSwift

class LoginCoordinator: BaseCoordinator {
    var navVC: UINavigationController
    private let disposeBag = DisposeBag()
    
    init(navVC: UINavigationController) {
        self.navVC = navVC
    }
    
    override func start() {
        let vc = LoginViewController.instantiate()
        let authManager = AuthManager.shared
        vc.viewModelBuilder = { [disposeBag] in
            let viewModel = LoginViewModel(input: $0, authManager: authManager)
            viewModel.input.createNewAccountButtonTapped.drive(onNext: { [weak self] in
                //　遷移処理
                self?.showRegister()
            }).disposed(by: disposeBag)
            
            viewModel.loginEventSubject.subscribe(onNext: {
                // Login完了 Home画面への遷移処理
            }).disposed(by: disposeBag)
            return viewModel
        }
        navVC.pushViewController(vc, animated: true)
    }
}

extension LoginCoordinator {
    func showRegister() {
        let coordnator = RegisterCoordinator(navVC: self.navVC)
        self.add(coordnator)
        coordnator.start()
        
    }
}
