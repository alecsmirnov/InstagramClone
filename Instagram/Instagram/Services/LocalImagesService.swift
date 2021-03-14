//
//  LocalImagesService.swift
//  Instagram
//
//  Created by Admin on 29.01.2021.
//

import Photos
import UIKit

final class LocalImagesService {
    // MARK: Properties
    
    var isEmpty: Bool {
        return imagesCount == 0
    }
    
    var imagesCount: Int {
        return assets?.count ?? 0
    }
    
    private(set) var currentImageIndex = 0
    
    private let imageRequestOptions = LocalImagesService.createImageRequestOptions()
    
    private var assets: PHFetchResult<PHAsset>?
    private let cachingImageManager = PHCachingImageManager()
    
    // MARK: Constants
    
    private enum SortDescriptorKeys {
        static let creationDate = "creationDate"
    }
    
    // MARK: Lifecycle
    
    init() {
        fetchImagesAssets()
    }
}

// MARK: - Public Methods

extension LocalImagesService {
    func fetchNextImages(
        targetSize: CGSize = PHImageManagerMaximumSize,
        count: Int,
        completion: @escaping ([UIImage]?) -> Void
    ) {
        var images: [(image: UIImage, index: Int)] = []
        let dispatchGroup = DispatchGroup()
        
        for _ in 0..<count {
            let imageIndex = currentImageIndex
            
            if imageIndex < imagesCount {
                dispatchGroup.enter()
                
                fetchImage(at: imageIndex, targetSize: targetSize) { image in
                    if let image = image {
                        images.append((image, imageIndex))
                    }
                    
                    dispatchGroup.leave()
                }
                
                currentImageIndex += 1
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let sortedImages = images.sorted(by: { $0.index < $1.index }).map { $0.image }
            
            completion(sortedImages)
        }
    }
    
    func fetchImage(
        at index: Int,
        targetSize: CGSize = PHImageManagerMaximumSize,
        completion: @escaping (UIImage?) -> Void
    ) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let asset = self?.assets?.object(at: index) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                
                return
            }
            
            self?.cachingImageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: self?.imageRequestOptions) { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                    
                    self?.cachingImageManager.startCachingImages(
                        for: [asset],
                        targetSize: targetSize,
                        contentMode: .default,
                        options: self?.imageRequestOptions)
                }
            }
        }
    }
    
    func resetCurrentImageIndex() {
        currentImageIndex = 0
    }
}

// MARK: - Private Methods

private extension LocalImagesService {
    func fetchImagesAssets() {
        let fetchOptions = PHFetchOptions()
    
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: SortDescriptorKeys.creationDate, ascending: false)]
        
        assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
    static func createImageRequestOptions() -> PHImageRequestOptions {
        let imageRequestOptions = PHImageRequestOptions()
        
        imageRequestOptions.isSynchronous = false
        imageRequestOptions.deliveryMode = .highQualityFormat
        
        return imageRequestOptions
    }
}
