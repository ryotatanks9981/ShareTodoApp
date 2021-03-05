import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, Storyboardable {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createNewAccountButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: LoginViewPresentable!
    var viewModelBuilder: LoginViewPresentable.ViewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ViewのBinding
        viewModel = viewModelBuilder((
            emailText: emailField.rx.text.orEmpty.asDriver(),
            passwordText: passwordField.rx.text.orEmpty.asDriver(),
            loginButtonTapped: loginButton.rx.tap.asDriver(),
            createNewAccountButtonTapped: createNewAccountButton.rx.tap.asDriver()
        ))
        
        setupViews()
        setupBinding()
    }
    
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        loginButton.layer.cornerRadius  = 5
        loginButton.layer.masksToBounds = true
    }
    
    private func setupBinding() {
        viewModel.output.isValid
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // isValidの値が流れてくる時の処理
        viewModel.output.isValid
            .drive(onNext: { [weak self] isValid in
                self?.loginButton.backgroundColor = isValid ? .systemPink : .init(white: 0.5, alpha: 0.7)
            }).disposed(by: disposeBag)

    }

}

