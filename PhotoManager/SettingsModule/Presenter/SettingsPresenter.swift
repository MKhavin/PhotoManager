import Foundation

protocol SettingsModulePresenter {
    init(view: SettingsView, userDefaults: UserDefaultsService, coordinator: MainCoordinator)
    func saveOrderSettings(order: OrderSettings)
    func showResetPasswordView()
    func getOrderSettings() -> OrderSettings
}

class SettingsPresenter: SettingsModulePresenter {
    private weak var view: SettingsView?
    let userDefaults: UserDefaultsService
    let coordinator: MainCoordinator
    
    required init(view: SettingsView, userDefaults: UserDefaultsService, coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self.view = view
        self.userDefaults = userDefaults
    }
    
    func saveOrderSettings(order: OrderSettings) {
        userDefaults.setOrderSettings(by: order.rawValue)
    }
    
    func showResetPasswordView() {
        coordinator.presentPasswordResetView()
    }
    
    func getOrderSettings() -> OrderSettings {
        userDefaults.getOrderSettings()
    }
}
