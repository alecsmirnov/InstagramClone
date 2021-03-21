//
//  LocalImagesService.swift
//  Instagram
//
//  Created by Admin on 29.01.2021.
//

import Photos

final class LocalImagesService {
    // MARK: Properties
    
    private(set) var currentImageIndex = 0
    
    var imagesCount: Int {
        return assets?.count ?? 0
    }
    
    private let imageRequestOptions = LocalImagesService.createImageRequestOptions()
    
    private var assets: PHFetchResult<PHAsset>?
    private let cachingImageManager = PHCachingImageManager()
    
    // MARK: Constants
    
    private enum SortDescriptorKeys {
        static let creationDate = "creationDate"
    }
    
    init() {
        fetchImagesAssets()
    }
}

// MARK: - Public Methods

extension LocalImagesService {
    func fetchNextImage(
        targetSize: CGSize = PHImageManagerMaximumSize,
        completion: @escaping (MediaFileType?) -> Void
    ) {
        if currentImageIndex < imagesCount {
            fetchImage(at: currentImageIndex, targetSize: targetSize, completion: completion)
        
            currentImageIndex += 1
        }
    }
    
    func fetchImage(
        at index: Int,
        targetSize: CGSize = PHImageManagerMaximumSize,
        completion: @escaping (MediaFileType?) -> Void
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
                        completion(.image(image))
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
        
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.deliveryMode = .highQualityFormat
        
        return imageRequestOptions
    }
}
