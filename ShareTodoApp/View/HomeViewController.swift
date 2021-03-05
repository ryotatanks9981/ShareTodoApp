import UIKit

class HomeViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: HomeViewPresentable!
    var viewModelBuilder: HomeViewPresentable.ViewModelBuilder!
    
    private let addTodoButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = addTodoButton
        viewModel = viewModelBuilder((
            addTodoTapped: addTodoButton.rx.tap.asDriver(), ()
        ))
        
        setupViews()
    }
    
    private func setupViews() {
        title = "Home"
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.size.width / 1.3
        let height = view.frame.size.height / 1.3
        return CGSize(width: width, height: height)
    }
}
