import UIKit
import RxSwift

class RegisterCoordinator: BaseCoordinator {
    var navVC: UINavigationController
    
    private let disposeBag = DisposeBag()
    
    init(navVC: UINavigationController) {
        self.navVC = navVC
    }
    
    override func start() {
        let vc = RegisterViewController.instantiate()
        vc.viewModelBuilder = {[disposeBag] in
            let viewModel = RegisterViewModel(input: $0)
            
            viewModel.input.alreadyHaveAccountButtonTapped.drive(onNext: { [weak self] in
                //遷移処理
                self?.showLoginCoordinator()
            }).disposed(by: disposeBag)
            
            viewModel.registerEventSubject.subscribe(onNext: {
                //Register完了の遷移処理
                print("かんせい！")
            }).disposed(by: disposeBag)
            
            return viewModel
        }
        navVC.pushViewController(vc, animated: true)
    }
}

private extension RegisterCoordinator {
    func showLoginCoordinator() {
        navVC.popViewController(animated: true)
        remove(self)
    }
}

