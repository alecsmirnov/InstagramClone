//
//  NewPostPresenter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostPresenter: AnyObject {
    func didPressCloseButton()
    func didPressContinueButton()
    
    func didRequestMedia()
    func didSelectMedia(atIndex index: Int)
}

final class NewPostPresenter {
    weak var viewController: INewPostViewController?
    var interactor: INewPostInteractor?
    var router: INewPostRouter?
}

// MARK: - INewPostPresenter

extension NewPostPresenter: INewPostPresenter {
    func didPressCloseButton() {
        router?.closeNewPostViewController()
    }
    
    func didPressContinueButton() {
        
    }
    
    func didRequestMedia() {
        interactor?.fetchMedia()
    }
    
    func didSelectMedia(atIndex index: Int) {
        interactor?.fetchMedia(at: index)
    }
}

// MARK: - INewPostInteractorOutput

extension NewPostPresenter: INewPostInteractorOutput {
    func fetchMediaSuccess(_ mediaFile: MediaFileType) {
        viewController?.appendMediaFile(mediaFile)
    }
    
    func fetchMediaSuccess(_ mediaFile: MediaFileType, at index: Int) {
        viewController?.setHeaderMediaFile(mediaFile)
    }
}
