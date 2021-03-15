//
//  SharePostPresenter.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

final class SharePostPresenter {
    // MARK: Properties
    
    weak var view: SharePostViewControllerProtocol?
    weak var coordinator: SharePostCoordinatorProtocol?
    
    var image: UIImage?
    
    private let sharePostService = SharePostService()
}

// MARK: - ISharePostPresenter

extension SharePostPresenter: SharePostViewControllerOutputProtocol {
    func viewDidLoad() {
        guard let image = image else { return }
        
        view?.setImage(image)
    }
    
    func didTapShareButton(withImage image: UIImage, caption: String?) {
        view?.showLoadingView()
        
        sharePostService.sharePost(withImage: image, caption: caption) { [weak self] error in
            guard error == nil else {
                self?.view?.hideLoadingView {
                    self?.view?.showAlert()
                }

                return
            }
            
            self?.view?.hideLoadingView()
            
            self?.coordinator?.closeSharePostViewController()
        }
    }
}
