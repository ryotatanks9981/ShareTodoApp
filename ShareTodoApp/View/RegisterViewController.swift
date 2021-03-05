import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: RegisterViewPresentable!
    var viewModelBuilder: RegisterViewPresentable.ViewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = viewModelBuilder((
            emailText: emailField.rx.text.orEmpty.asDriver(),
            passwordText: passwordField.rx.text.orEmpty.asDriver(),
            registerButtonTapped: registerButton.rx.tap.asDriver(),
            alreadyHaveAccountButtonTapped: alreadyHaveAccountButton.rx.tap.asDriver()
        ))
        
        setupViews()
        setupBind()
    }
    
    private func setupViews() {
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
    }
    
    private func setupBind() {
        viewModel.output.isValid
            .drive(registerButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.output.isValid
            .drive(onNext: { [weak self] isValid in
                self?.registerButton.backgroundColor = isValid ? .systemPink : .init(white: 0.5, alpha: 0.7)
            }).disposed(by: disposeBag)
            
    }
}
