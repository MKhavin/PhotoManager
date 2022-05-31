import Foundation

protocol UserDefaultsService: AnyObject {
    func getOrderSettings() -> OrderSettings
    func setOrderSettings(by value: String)
}

enum OrderSettings: String {
    case ascending = "arrow.up.square"
    case descending = "arrow.down.square"
}

class AppSettings: UserDefaultsService {
    func getOrderSettings() -> OrderSettings {
        let value = UserDefaults.standard.string(forKey: "PhotosOrder")
        
        if value != nil {
            return .init(rawValue: value!) ?? .descending
        }
        
        return .descending
    }
    
    func setOrderSettings(by value: String) {
        UserDefaults.standard.set(value, forKey: "PhotosOrder")
    }
}
