import UIKit

enum SettingsOperation {
    enum PhotosOrder: String {
        case ascending = "arrow.up.app"
        case descending = "arrow.down.app"
    }
    
    case setPhotosOrder(order: OrderSettings?)
    case resetPassword
    
    static let count = 2
    
    var id: String {
        switch self {
        case .setPhotosOrder:
            return "PhotosOrder"
        case .resetPassword:
            return "ResetPassword"
        }
    }
    
    var name: String {
        switch self {
        case .setPhotosOrder(_):
            return "Change photos order"
        case .resetPassword:
            return "Reset password"
        }
    }
}

class SettingsTableViewCell: UITableViewCell {
    var operation: SettingsOperation?
    
    func setCellConfiguration(for operation: SettingsOperation) {
        self.operation = operation
        
        var config = defaultContentConfiguration()
        config.text = self.operation?.name
        contentConfiguration = config
        
        switch operation {
        case .setPhotosOrder(let order):
            accessoryView = UIImageView(image: UIImage(systemName: order?.rawValue ?? ""))
        default:
            break
        }
    }
}
