import UIKit

protocol MainCoordinator {
    var navigationController: UINavigationController? { get set }
    var builder: ModuleAssembly { get set }
    func pushInitialController()
    func pushMainController()
    func popTo(controller: UIViewController)
    func presentPasswordResetView()
    init(navigationController: UINavigationController, builder: ModuleAssembly)
}

class Coordinator: MainCoordinator {
    weak var navigationController: UINavigationController?
    var builder: ModuleAssembly
    
    required init(navigationController: UINavigationController, builder: ModuleAssembly) {
        self.navigationController = navigationController
        self.builder = builder
    }
        
    func pushInitialController() {
        let controller = builder.buildLogInModule(coordinator: self, isPasswordResetMode: false)
        navigationController?.pushViewController(controller,
                                                 animated: true)
        controller.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func pushMainController() {
        navigationController?.pushViewController(builder.buildInitialController(coordinator: self),
                                                 animated: true)
    }
    
    func popTo(controller: UIViewController) {
        navigationController?.pushViewController(controller,
                                                 animated: true)
    }
    
    func presentPasswordResetView() {
        let controller = builder.buildLogInModule(coordinator: self, isPasswordResetMode: true)
        navigationController?.present(controller,
                                      animated: true)
    }
}
