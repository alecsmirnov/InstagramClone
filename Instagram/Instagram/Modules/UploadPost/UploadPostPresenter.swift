//
//  UploadPostPresenter.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

protocol IUploadPostPresenter: AnyObject {
    func viewDidLoad()
    
    func didPressUploadButton()
}

final class UploadPostPresenter {
    // MARK: Properties
    
    weak var viewController: IUploadPostViewController?
    var interactor: IUploadPostInteractor?
    var router: IUploadPostRouter?
    
    var mediaFile: MediaFileType?
}

// MARK: - IUploadPostPresenter

extension UploadPostPresenter: IUploadPostPresenter {
    func viewDidLoad() {
        guard let mediaFile = mediaFile else { return }
        
        viewController?.setMediaFile(mediaFile)
    }
    
    func didPressUploadButton() {
        
    }
}

// MARK: - IUploadPostInteractorOutput

extension UploadPostPresenter: IUploadPostInteractorOutput {

}
