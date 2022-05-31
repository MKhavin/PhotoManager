import UIKit

// MARK: Protocol description
protocol SettingsView: AnyObject {
    var presenter: SettingsModulePresenter! { get set }
}

// MARK: View properties
class SettingsViewController: UIViewController, SettingsView {
    static let cellIdentifier = "SettingsCell"
    var presenter: SettingsModulePresenter!
    
    lazy var settingsTableView: UITableView = {
        let view = UITableView()
        
        view.dataSource = self
        view.delegate = self
        view.register(SettingsTableViewCell.self,
                      forCellReuseIdentifier: SettingsViewController.cellIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
}

// MARK: View life cycle
extension SettingsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(settingsTableView)
        setLayout()
        setNavigationBar()
    }
}

// MARK: Sub functions
extension SettingsViewController {
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.tabBarItem.image = UIImage(systemName: "gearshape")
        navigationController?.tabBarItem.title = "Settings"
    }
}

// MARK: Table view datasource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingsOperation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.cellIdentifier,
                                                       for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.setCellConfiguration(for: .setPhotosOrder(order: presenter.getOrderSettings()))
        case 1:
            cell.setCellConfiguration(for: .resetPassword)
        default: break
        }
       
        return cell
    }
}

// MARK: Table View delegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell else {
            return
        }
        
        if let currentOperation = cell.operation {
            switch currentOperation {
            case .setPhotosOrder(let order):
                let newSetting = (order == .descending ? OrderSettings.ascending : OrderSettings.descending)
                presenter.saveOrderSettings(order: newSetting)
                cell.setCellConfiguration(for: .setPhotosOrder(order: newSetting))
            case .resetPassword:
                presenter.showResetPasswordView()
            }
        }
    }
}
