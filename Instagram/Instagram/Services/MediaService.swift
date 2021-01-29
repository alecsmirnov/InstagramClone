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
        static let defaultTargetSize = CGSize(width: 200, height: 200)
    }
}

// MARK: - Public Methods

extension MediaService {
    static func fetchImages(fetchLimit: Int = 0, targetSize: CGSize = Constants.defaultTargetSize) -> [MediaFileType] {
        var images = [MediaFileType]()
        
        let imagesAssets = createImageAssets(fetchLimit: fetchLimit)
        let imageRequestOptions = createImageRequestOptions(async: false)
        
        imagesAssets.enumerateObjects { asset, _, _ in
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: imageRequestOptions) { image, _ in
                if let image = image {
                    images.append(.image(image))
                }
            }
        }
        
        return images
    }
    
    static func fetchImagesAsync(
        fetchLimit: Int = 0,
        targetSize: CGSize = Constants.defaultTargetSize,
        completion: @escaping (MediaFileType) -> Void
    ) {
        let imagesAssets = createImageAssets(fetchLimit: fetchLimit)
        let imageRequestOptions = createImageRequestOptions(async: false)
        
        DispatchQueue.global(qos: .background).async {
            imagesAssets.enumerateObjects { asset, _, _ in
                PHImageManager.default().requestImage(
                    for: asset,
                    targetSize: targetSize,
                    contentMode: .aspectFit,
                    options: imageRequestOptions) { image, _ in
                    if let image = image {
                        DispatchQueue.main.async {
                            completion(.image(image))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension MediaService {
    static func createImageAssets(fetchLimit: Int) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.fetchLimit = fetchLimit
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: SortDescriptorKeys.creationDate, ascending: false)]
        
        let imagesAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        return imagesAssets
    }
    
    static func createImageRequestOptions(async: Bool) -> PHImageRequestOptions {
        let imageRequestOptions = PHImageRequestOptions()
        
        imageRequestOptions.isSynchronous = !async
        imageRequestOptions.deliveryMode = .highQualityFormat
        
        return imageRequestOptions
    }
}
