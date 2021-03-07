//
//  ImageCachingService.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

final class ImageCachingService {
    // MARK: Properties
    
    static let shared = ImageCachingService()
    
    private let storage = NSCache<NSString, AnyObject>()
    
    // MARK: Initialization
    
    private init() {}
}

// MARK: - Public Methods

extension ImageCachingService {
    func setImage(_ image: UIImage, forKey key: String) {
        storage.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage? {
        guard let image = storage.object(forKey: key as NSString) as? UIImage else { return nil }
        
        return image
    }
}
