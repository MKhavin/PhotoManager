import Foundation

protocol PhotosPresenter: AnyObject {
    var photosCollection: [String]? { get }
    init(view: PhotosView, fileManager: FileManagerService)
    func getImagesCollection()
    func deleteImage(photo: Int)
    func addImage(by data: Data?)
}

class PhotoPresenter: PhotosPresenter {
    private weak var view: PhotosView?
    private let fileManager: FileManagerService
    private(set) var photosCollection: [String]?
    
    required init(view: PhotosView, fileManager: FileManagerService) {
        self.view = view
        self.fileManager = fileManager
        getImagesCollection()
    }
    
    func getImagesCollection() {
        let result = fileManager.getImagesCollection()
        switch result {
        case .success(let collection):
            photosCollection = collection
        case .failure(let error):
            view?.showError(message: error.localizedDescription)
        }
    }
    
    func deleteImage(photo: Int) {
        guard let collection = photosCollection else {
            return
        }
        
        let result = fileManager.removeImage(path: collection[photo])
        
        switch result {
        case .success(_):
            photosCollection?.remove(at: photo)
            view?.deleteFromPhotosCollection(photo: photo)
        case .failure(let error):
            view?.showError(message: error.localizedDescription)
        }
    }
    
    func addImage(by data: Data?) {
        let photoNumber = (photosCollection?.count ?? 0) + 1
        
        if fileManager.addImage(data: data,
                                imageName: "Photo\(photoNumber).png") {
            getImagesCollection()
            DispatchQueue.main.async {[weak self] in
                self?.view?.insertIntoPhotosCollection(photo: photoNumber - 1)
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.view?.showError(message: "Error")
            }
        }
    }
}
