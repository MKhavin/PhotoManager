import Foundation
import UIKit

protocol ModuleAssembly {
    func buildPhotoModule(coordinator: MainCoordinator) -> UIViewController
    func buildSettingsModule(coordinator: MainCoordinator) -> UIViewController
    func buildLogInModule(coordinator: MainCoordinator, isPasswordResetMode: Bool) -> UIViewController
    func buildInitialController(coordinator: MainCoordinator) -> UIViewController
}

class ModuleBuilder: ModuleAssembly {
    func buildInitialController(coordinator: MainCoordinator) -> UIViewController {
        let tabBarController = UITabBarController()
        
        let navController = UINavigationController()
        navController.viewControllers = [buildPhotoModule(coordinator: coordinator)]
        
        let settingsNavController = UINavigationController()
        settingsNavController.setViewControllers([buildSettingsModule(coordinator: coordinator)],
                                                 animated: false)
        settingsNavController.tabBarItem.image = UIImage(systemName: "gearshape")
        settingsNavController.tabBarItem.title = "Settings"
        
        tabBarController.setViewControllers([navController, settingsNavController], animated: false)
        tabBarController.selectedIndex = 0
        
        return tabBarController
    }
    
    func buildPhotoModule(coordinator: MainCoordinator) -> UIViewController {
        let fileManager = FileManagerService()
        let userDefaults = AppSettings()
        let view = PhotoViewController()
        let presenter = PhotoPresenter(view: view,
                                       fileManager: fileManager,
                                       userDefaults: userDefaults,
                                       coordinator: coordinator)
        view.presenter = presenter
        
        return view
    }
    
    func buildSettingsModule(coordinator: MainCoordinator) -> UIViewController {
        let view = SettingsViewController()
        let userDefaults = AppSettings()
        let presenter = SettingsPresenter(view: view, userDefaults: userDefaults, coordinator: coordinator)
        view.presenter = presenter
        
        return view
    }
    
    func buildLogInModule(coordinator: MainCoordinator, isPasswordResetMode: Bool) -> UIViewController {
        let view = LogInViewController()
        let keychain = Keychain()
        let presenter = LogInPresenter(view: view,
                                       coordinator: coordinator,
                                       keychain: keychain,
                                       isPasswordResetMode: isPasswordResetMode)
        view.presenter = presenter
        return view
    }
}
