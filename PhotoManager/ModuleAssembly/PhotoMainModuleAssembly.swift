import UIKit

struct PhotoMainModuleAssembly: ModuleAssembly {
    static func build() -> UIViewController {
        let fileManager = FileManagerService()
        let view = PhotoViewController()
        let presenter = PhotoPresenter(view: view, fileManager: fileManager)
        view.presenter = presenter
        
        return view
    }
}
