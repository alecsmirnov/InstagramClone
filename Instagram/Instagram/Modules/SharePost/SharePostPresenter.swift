//
//  SharePostPresenter.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

protocol IUploadPostPresenter: AnyObject {
    func viewDidLoad()
    
    func didPressShareButton(withMediaFile mediaFile: MediaFileType, caption: String?)
}

final class SharePostPresenter {
    // MARK: Properties
    
    weak var viewController: ISharePostViewController?
    var interactor: ISharePostInteractor?
    var router: ISharePostRouter?
    
    var mediaFile: MediaFileType?
}

// MARK: - ISharePostPresenter

extension SharePostPresenter: IUploadPostPresenter {
    func viewDidLoad() {
        guard let mediaFile = mediaFile else { return }
        
        viewController?.setMediaFile(mediaFile)
    }
    
    func didPressShareButton(withMediaFile mediaFile: MediaFileType, caption: String?) {
        interactor?.sharePost(withMediaFile: mediaFile, caption: caption)
    }
}

// MARK: - ISharePostInteractorOutput

extension SharePostPresenter: ISharePostInteractorOutput {
    func sharePostSuccess() {
        router?.closeSharePostViewController()
    }
    
    func sharePostFailure() {
        
    }
}
