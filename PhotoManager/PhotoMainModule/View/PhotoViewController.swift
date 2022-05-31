import UIKit
import PhotosUI

//MARK: View protocol
protocol PhotosView: AnyObject {
    var presenter: PhotosPresenter! { get set }
    func showError(message: String)
    func deleteFromPhotosCollection(photo: Int)
    func insertIntoPhotosCollection(photo: Int)
    func updatePhotoCollection()
}

class PhotoViewController: UIViewController, PhotosView {
    //MARK: Service properties
    var presenter: PhotosPresenter!
    private static let cellIdentifier = "PhotoCell"
    
    //MARK: View elements
    lazy var photosCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(PhotoCollectionViewCell.self,
                            forCellWithReuseIdentifier: PhotoViewController.cellIdentifier)
        return collection
    }()
}

//MARK: VC Life Cycle
extension PhotoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(photosCollection)
        
        setTabBarItem()
        setNavigationBar()
        setLayout()
        setCollectionGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.setImagesCollectionOrder()
        photosCollection.reloadData()
    }
}

//MARK: Serfice Functions
extension PhotoViewController {
    private func setTabBarItem() {
        navigationController?.tabBarItem.title = "Photos"
        navigationController?.tabBarItem.image = UIImage(systemName: "photo.on.rectangle.angled")
    }
    
    private func setNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(addImage(_:)))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Photos"
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            photosCollection.topAnchor.constraint(equalTo: safeArea.topAnchor),
            photosCollection.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            photosCollection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            photosCollection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error occured",
                                      message: message,
                                      preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true)
        }
        alert.addAction(doneAction)
        
        present(alert, animated: true)
    }
    
    private func setCollectionGesture() {
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(showItemOptions(_:)))
        gesture.minimumPressDuration = 0.5
        gesture.delaysTouchesBegan = true
        photosCollection.addGestureRecognizer(gesture)
    }
    
    func insertIntoPhotosCollection(photo: Int) {
        photosCollection.insertItems(at: [IndexPath(item: photo, section: 0)])
    }
    
    func deleteFromPhotosCollection(photo: Int) {
        photosCollection.deleteItems(at: [IndexPath(item: photo, section: 0)])
    }
    
    func updatePhotoCollection() {
        photosCollection.reloadData()
    }
}

//MARK: Actions
extension PhotoViewController {
    @objc private func addImage(_ sender: UIBarButtonItem) {
        var pickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        pickerConfiguration.selectionLimit = 1
        pickerConfiguration.filter = .images
        
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    @objc private func showItemOptions(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        
        let touchCoordinates = sender.location(in: photosCollection)
        
        if let indexPath = photosCollection.indexPathForItem(at: touchCoordinates) {
            let optionsAlert = UIAlertController(title: nil,
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
            
            let cancelButton = UIAlertAction(title: "Cancel",
                                             style: .cancel) { action in
                self.dismiss(animated: true)
            }
            let deleteButton = UIAlertAction(title: "Delete",
                                             style: .destructive) { [weak presenter] action in
                presenter?.deleteImage(photo: indexPath.item)
                self.dismiss(animated: true)
            }
            
            optionsAlert.addAction(deleteButton)
            optionsAlert.addAction(cancelButton)
        
            self.present(optionsAlert, animated: true)
        }
    }
}

//MARK: CollectionView Data Source
extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.photosCollection?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewController.cellIdentifier,
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setImage(by: presenter.photosCollection?[indexPath.item] ?? "")
        
        return cell
    }
}

//MARK: CollectionView Delegate
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenBounds = UIScreen.main.bounds
        return CGSize(width: screenBounds.width,
               height: screenBounds.height / 3)
    }
}

//MARK: PhotoPicker Delegate
extension PhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach {[weak presenter] result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { data, error in
                guard let image = data as? UIImage else {
                    return
                }
                
                presenter?.addImage(by: image.pngData())
            }
        }
    }
}
