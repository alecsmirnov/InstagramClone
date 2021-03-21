//
//  SharePostService.swift
//  Instagram
//
//  Created by Admin on 15.03.2021.
//

import UIKit

final class SharePostService {
    private enum Constants {
        static let imageCompressionQuality: CGFloat = 0.75
    }
}

// MARK: - Public Methods

extension SharePostService: SharePostServiceProtocol {
    func sharePost(withImage image: UIImage, caption: String?, completion: @escaping (Error?) -> Void) {
        guard
            let userIdentifier = FirebaseAuthService.currentUserIdentifier,
            let imageData = image.jpegData(compressionQuality: Constants.imageCompressionQuality)
        else {
            return
        }
        
        let imageAspectRatio = image.size.width / image.size.height
        
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
