protocol LogInPresenterProtocol {
    func checkPasswordExistance()
    func confirmPassword(firstPassword: String, secondPassword: String)
    init(view: LogInView,
         coordinator: MainCoordinator,
         keychain: KeychainService,
         isPasswordResetMode: Bool)
}

class LogInPresenter: LogInPresenterProtocol {
    weak var view: LogInView?
    var coordinator: MainCoordinator
    private var password: String?
    private var isLogInMode: Bool = false
    private var isPasswordResetMode: Bool
    private let keychain: KeychainService
    
    func checkPasswordExistance() {
        password = keychain.getValue()
        isLogInMode = password == nil || isPasswordResetMode ? false : true
        view?.setUIElements(by: isLogInMode)
    }
    
    required init(view: LogInView,
                  coordinator: MainCoordinator,
                  keychain: KeychainService,
                  isPasswordResetMode: Bool) {
        self.view = view
        self.coordinator = coordinator
        self.isPasswordResetMode = isPasswordResetMode
        self.keychain = keychain
    }
    
    func confirmPassword(firstPassword: String, secondPassword: String) {
        let trimPassword = firstPassword.trimmingCharacters(in: .whitespaces)
        guard trimPassword.count >= 4 else {
            view?.showErrorMessage(message: "Password's length is less than 4 symbols.")
            return
        }
        
        guard isLogInMode || firstPassword == secondPassword else {
            view?.showErrorMessage(message: "Passwords aren't identical.")
            return
        }
        
        
        var errorMessage: String?
        switch isLogInMode {
        case true:
            if firstPassword == password {
                coordinator.pushMainController()
            } else {
                errorMessage = "Password is incorrect."
            }
        case false:
            errorMessage = keychain.setValue(firstPassword)?.localizedDescription
            if errorMessage == nil {
                if isPasswordResetMode {
                    view?.close()
                } else {
                    coordinator.pushMainController()
                }
            }
        }
        
        if let message = errorMessage {
            view?.showErrorMessage(message: message)
        }
    }
    
}
