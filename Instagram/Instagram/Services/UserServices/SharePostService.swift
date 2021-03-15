//
//  SharePostService.swift
//  Instagram
//
//  Created by Admin on 15.03.2021.
//

import UIKit

struct SharePostService {
    private enum Constants {
        static let defaultCompressionQuality: CGFloat = 0.75
    }
}

// MARK: - Public Methods

extension SharePostService {
    func sharePost(
        withImage image: UIImage,
        caption: String?,
        imageCompressionQuality: CGFloat = Constants.defaultCompressionQuality,
        completion: @escaping (Error?) -> Void
    ) {
        guard let userIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        let croppedImage = image.instagramCrop() ?? image
        
        guard let imageData = croppedImage.jpegData(compressionQuality: imageCompressionQuality) else { return }
        
        let imageAspectRatio = croppedImage.size.width / croppedImage.size.height
        let caption = (caption?.isEmpty ?? true) ? nil : caption
        
        FirebaseDatabaseService.sharePost(
            userIdentifier: userIdentifier,
            imageData: imageData,
            imageAspectRatio: imageAspectRatio,
            caption: caption) { error in
            if let error = error {
                print("Failed to share post: \(error.localizedDescription)")
            }
            
            completion(error)
        }
    }
}
