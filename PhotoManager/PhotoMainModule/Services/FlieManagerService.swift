import Foundation
import UIKit

class FileManagerService {
    private let url: URL = {
        do {
            let url = try FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false)
            return url
        } catch {
            return URL(fileURLWithPath: "")
        }
    }()
    
    func addImage(data: Data?, imageName: String) -> Bool {
        let imagePath = url.appendingPathComponent(imageName)
        
        let result = FileManager.default.createFile(atPath: imagePath.path, contents: data)
        return result
    }
    
    func removeImage(path: String) -> Result<Bool, Error> {
        do {
            try FileManager.default.removeItem(atPath: path)
            return.success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func getImagesCollection() -> Result<[String], Error> {
        do {
            let content = try FileManager.default.contentsOfDirectory(at: url,
                                                                      includingPropertiesForKeys: nil)
            let pathContent = content.map { url in
                url.path
            }
            return .success(pathContent.sorted(by: { $0 < $1 }))
        } catch {
            return .failure(error)
        }
    }
}
