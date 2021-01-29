//
//  MediaService.swift
//  Instagram
//
//  Created by Admin on 29.01.2021.
//

import Photos
import UIKit

enum MediaService {
    // MARK: Constants
    
    private enum SortDescriptorKeys {
        static let creationDate = "creationDate"
    }
    
    private enum Constants {
        static let defaultTargetSize = CGSize(width: 300, height: 300)
    }
}

// MARK: - Public Methods

extension MediaService {
    static func fetchImages(fetchLimit: Int = 0, targetSize: CGSize = Constants.defaultTargetSize) -> [MediaFileType] {
        var images = [MediaFileType]()
        
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.fetchLimit = fetchLimit
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: SortDescriptorKeys.creationDate, ascending: false)]
        
        let imagesAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let imageRequestOptions = PHImageRequestOptions()
        
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.deliveryMode = .highQualityFormat
        
        imagesAssets.enumerateObjects { asset, _, _ in
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: imageRequestOptions) { image, info in
                if let image = image {
                    images.append(.image(image))
                }
            }
        }
        
        return images
    }
}
