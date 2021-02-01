//
//  UploadPostPresenter.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

protocol IUploadPostPresenter: AnyObject {
    
}

final class UploadPostPresenter {
    weak var viewController: IUploadPostViewController?
    var interactor: IUploadPostInteractor?
    var router: IUploadPostRouter?
}

// MARK: - IUploadPostPresenter

extension UploadPostPresenter: IUploadPostPresenter {
    
}

// MARK: - IUploadPostInteractorOutput

extension UploadPostPresenter: IUploadPostInteractorOutput {

}
