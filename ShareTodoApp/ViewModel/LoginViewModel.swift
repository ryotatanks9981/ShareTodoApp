import Foundation
import RxSwift
import RxCocoa

protocol LoginViewPresentable {
    typealias Input = (
        emailText: Driver<String>,
        passwordText: Driver<String>,
        loginButtonTapped: Driver<()>,
        createNewAccountButtonTapped: Driver<()>
    )
    typealias Output = (
        isValid: Driver<Bool>, ()
    )
    
    typealias ViewModelBuilder = (LoginViewPresentable.Input) -> LoginViewPresentable
    
    var input: LoginViewPresentable.Input { get }
    var output: LoginViewPresentable.Output { get }
}

class LoginViewModel: LoginViewPresentable {
    var input : LoginViewPresentable.Input
    var output: LoginViewPresentable.Output
    
    private let emailBehaviorRelay = BehaviorRelay<String>(value: "")
    private let passwordBehaviorRelay = BehaviorRelay<String>(value: "")
    
    var loginEventSubject = PublishSubject<()>()
    
    private let disposeBag = DisposeBag()
    
    private let authManager: AuthProtocol
    
    init(input: LoginViewPresentable.Input, authManager: AuthProtocol) {
        self.input = input
        self.output = LoginViewModel.output(input: self.input)
        
        self.authManager = authManager
    }
}

private extension LoginViewModel {
    static func output(input: LoginViewModel.Input) -> LoginViewPresentable.Output {
        let isValid = Driver.combineLatest(input.emailText, input.passwordText) { (email, password) -> Bool in
            Validator.shared.emailValidate(email: email) && Validator.shared.passwordValidate(passowrd: password)
        }
        
        return (
            isValid: isValid, ()
        )
    }
    
    func bind() {
        input.emailText
            .drive(emailBehaviorRelay)
            .disposed(by: disposeBag)
        
        input.passwordText
            .drive(passwordBehaviorRelay)
            .disposed(by: disposeBag)
    }
    
    func process() {
        self.input.loginButtonTapped.drive(onNext: { [unowned self] in
            let email = self.emailBehaviorRelay.value
            let password = self.passwordBehaviorRelay.value
            // login処理
            authManager.signIn(email: email, passowrd: password) {
                self.loginEventSubject.onNext(())
            }
        }).disposed(by: disposeBag)
    }
}
