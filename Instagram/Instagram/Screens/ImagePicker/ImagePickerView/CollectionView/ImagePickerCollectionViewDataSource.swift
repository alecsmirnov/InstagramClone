//
//  ImagePickerCollectionViewDataSource.swift
//  Instagram
//
//  Created by Admin on 14.03.2021.
//

import UIKit

final class ImagePickerCollectionViewDataSource: NSObject {
    // MARK: Properties
    
    var lastCellPresentedCompletion: (() -> Void)?
    
    var imagesCount: Int {
        return images.count
    }
    
    var headerViewKind: HeaderViewKind = .image
    
    private var images: [UIImage] = []
    
    // MARK: Constants
    
    enum HeaderViewKind {
        case image
        case noImages
    }
}

// MARK: - Public Methods

extension ImagePickerCollectionViewDataSource {
    func appendImage(_ image: UIImage) {
        images.append(image)
    }
    
    func appendImages(_ images: [UIImage]) {
        self.images.append(contentsOf: images)
    }
    
    func getImage(at index: Int) -> UIImage? {
        guard images.indices.contains(index) else { return nil }
        
        return images[index]
    }
}

// MARK: - UICollectionViewDataSource

extension ImagePickerCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCell.reuseIdentifier,
            for: indexPath) as? ImageCell
        else {
            return UICollectionViewCell()
        }
        
        cell.image = images[indexPath.row]
        
        if indexPath.row == images.count - 1 {
            lastCellPresentedCompletion?()
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch headerViewKind {
        case .image:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ImageHeaderView.reuseIdentifier,
                for: indexPath) as? ImageHeaderView
            else {
                return UICollectionReusableView()
            }
            
            return header
        case .noImages:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: NoImagesHeaderView.reuseIdentifier,
                for: indexPath) as? NoImagesHeaderView
            else {
                return UICollectionReusableView()
            }
            
            return header
        }
    }
}
