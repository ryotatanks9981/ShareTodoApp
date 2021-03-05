import Foundation
import RxSwift
import RxCocoa

protocol HomeViewPresentable {
    typealias Input = (
        addTodoTapped: Driver<()>, ()
    )
    typealias Output = (
        todos: Driver<[TodoModel]>, ()
    )
    typealias ViewModelBuilder = (HomeViewPresentable.Input) -> HomeViewPresentable
    
    var input: HomeViewPresentable.Input { get }
    var output: HomeViewPresentable.Output { get }
}

class HomeViewModel: HomeViewPresentable {
    var input: HomeViewPresentable.Input
    var output: HomeViewPresentable.Output
    
    private let storeManager: StoreTodoProtocol
    
    init(input: HomeViewPresentable.Input, storeManager: StoreTodoProtocol) {
        self.input = input
        
        self.output = HomeViewModel.output(input: self.input, storeManager: storeManager)
        self.storeManager = storeManager
    }
}

extension HomeViewModel {
    static func output(input: HomeViewPresentable.Input, storeManager: StoreTodoProtocol) -> HomeViewModel.Output {
        let todos = storeManager.fetchTodosFromFirestore().asDriver(onErrorJustReturn: [])
        return (
            todos: todos, ()
        )
    }
}
