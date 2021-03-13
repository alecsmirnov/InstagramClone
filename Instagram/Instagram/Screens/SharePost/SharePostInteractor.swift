//
//  SharePostInteractor.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol ISharePostInteractor: AnyObject {
    func sharePost(withMediaFile mediaFile: UIImage, caption: String?)
}

protocol ISharePostInteractorOutput: AnyObject {
    func sharePostSuccess()
    func sharePostFailure()
}

final class SharePostInteractor {
    weak var presenter: ISharePostInteractorOutput?
}

// MARK: - ISharePostInteractor

extension SharePostInteractor: ISharePostInteractor {
    func sharePost(withMediaFile mediaFile: UIImage, caption: String?) {
        guard let userIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        let croppedImage = mediaFile.instagramCrop() ?? mediaFile
        
        guard let imageData = croppedImage.jpegData(
            compressionQuality: SharePostConstants.Constants.imageCompressionQuality) else { return }
        
        let imageAspectRatio = croppedImage.size.width / croppedImage.size.height
        let caption = (caption?.isEmpty ?? true) ? nil : caption
        
        FirebaseDatabaseService.sharePost(
            userIdentifier: userIdentifier,
            imageData: imageData,
            imageAspectRatio: imageAspectRatio,
            caption: caption) { [self] error in
            if let error = error {
                presenter?.sharePostFailure()
                
                print("Failed to share post: \(error.localizedDescription)")
            } else {
                presenter?.sharePostSuccess()
                
                print("Post successfully shared")
            }
        }
    }
}
