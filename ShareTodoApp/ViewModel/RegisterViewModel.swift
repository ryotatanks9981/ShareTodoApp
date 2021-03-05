import RxSwift
import RxCocoa

protocol RegisterViewPresentable {
    typealias Input = (
        emailText: Driver<String>,
        passwordText: Driver<String>,
        registerButtonTapped: Driver<()>,
        alreadyHaveAccountButtonTapped: Driver<()>
    )
    typealias Output = (
        isValid: Driver<Bool>, ()
    )
    
    typealias ViewModelBuilder = (RegisterViewPresentable.Input) -> RegisterViewPresentable
    
    var input: RegisterViewPresentable.Input { get }
    var output: RegisterViewPresentable.Output { get }
}

class RegisterViewModel: RegisterViewPresentable {
    var input: RegisterViewPresentable.Input
    var output: RegisterViewPresentable.Output
    
    private let disposeBag = DisposeBag()
    
    private let emailBehaviorRelay = BehaviorRelay<String>(value: "")
    private let passwordBehaviorRelay = BehaviorRelay<String>(value: "")
    
    var registerEventSubject = PublishSubject<()>()
    
    init(input: RegisterViewPresentable.Input) {
        self.input = input
        self.output = RegisterViewModel.output(input: self.input)
        
        bind()
        process()
    }
}

private extension RegisterViewModel {
    static func output(input: RegisterViewPresentable.Input) -> RegisterViewPresentable.Output {
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
        
        input.registerButtonTapped.drive(onNext: { [unowned self] in
            //新規登録の処理
            let email = self.emailBehaviorRelay.value
            let password = self.passwordBehaviorRelay.value
            AuthManager.shared.createAccount(email: email, passowrd: password) {(user) in
                StoreUserManager.shared.createNewAccount(user: user) {
                    self.registerEventSubject.onNext(())
                }
            }
        }).disposed(by: disposeBag)
    }
}
