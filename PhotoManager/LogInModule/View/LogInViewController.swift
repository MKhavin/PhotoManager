import UIKit

// MARK: Protocol description
protocol LogInView: AnyObject {
    func close()
    func setUIElements(by isLogIn: Bool)
    func showErrorMessage(message: String)
}

// MARK: View properties
class LogInViewController: UIViewController {

    var presenter: LogInPresenterProtocol!
    
    lazy var passwordTextField: UITextField = {
       let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Password"
        view.backgroundColor = .systemGray5
        view.borderStyle = .bezel
        view.isSecureTextEntry = true
        return view
    }()
    
    lazy var confirmPasswordTextField: UITextField = {
       let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Confirm password"
        view.backgroundColor = .systemGray5
        view.borderStyle = .bezel
        view.isSecureTextEntry = true
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Write your password"
        view.textAlignment = .center
        return view
    }()
}

// MARK: View life cycle
extension LogInViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(passwordTextField)
        view.addSubview(confirmButton)
        view.addSubview(label)
        view.addSubview(confirmPasswordTextField)
        
        setLayout()
        presenter.checkPasswordExistance()
    }
}

// MARK: Sub functions
extension LogInViewController {
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            confirmButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 1),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -30),
            label.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: Actions
extension LogInViewController {
    @objc func confirmButtonTapped(_ sender: UIButton) {
        presenter.confirmPassword(firstPassword: passwordTextField.text ?? "",
                                  secondPassword: confirmPasswordTextField.text ?? "")
    }
}

// MARK: Protocol functions
extension LogInViewController: LogInView {
    func close() {
        dismiss(animated: true)
    }
    
    func setUIElements(by isLogInMode: Bool) {
        confirmButton.setTitle(isLogInMode ? "Log In" : "Register",
                               for: .normal)
        confirmPasswordTextField.isHidden = isLogInMode
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error occured",
                                      message: message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            self.dismiss(animated: true)
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
