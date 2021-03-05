import UIKit
import FirebaseAuth

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        let navigationBar = navigationController.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = .init(red: 233/255, green: 55/255, blue: 72/255, alpha: 1)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            .font: UIFont(name: "Avenir-Medium", size: 28)!,
            .foregroundColor: UIColor.white
        ]
        navigationBar.isTranslucent = false
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        // 最初に表示するViewController の Coordinator を実装
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let coordintor = LoginCoordinator(navVC: self.navigationController)
                self.add(coordintor)
                coordintor.start()
            } else {
                let coordintor = HomeCoordinator(navVC: self.navigationController)
                self.add(coordintor)
                coordintor.start()
            }
        })
        
        
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
