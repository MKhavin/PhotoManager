//
//  PhotoCollectionViewCell.swift
//  PhotoManager
//
//  Created by Michael Khavin on 21.05.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            image.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setImage(by path: String) {
        image.image = UIImage(contentsOfFile: path)
    }
}
