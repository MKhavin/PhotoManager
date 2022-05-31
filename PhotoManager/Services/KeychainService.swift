import Foundation
import KeychainAccess

protocol KeychainService {
    func setValue(_ value: String) -> Error?
    func getValue() -> String?
}

struct Keychain: KeychainService {
    
    private let keychain = KeychainAccess.Keychain(service: "com.MichaelK.PhotoManager")
    
    func setValue(_ value: String) -> Error? {
        do {
            try keychain.set(value, key: "password")
            return nil
        } catch {
            return error
        }
    }
    
    func getValue() -> String? {
        return try? keychain.get("password")
    }
    
}
