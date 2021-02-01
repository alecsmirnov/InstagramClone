//
//  NewPostPresenter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostPresenter: AnyObject {
    func didPressCloseButton()
    func didPressContinueButton(with: MediaFileType?)
    
    func didRequestCellMedia()
    func didRequestOriginalMedia(at index: Int)
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
    
    func didPressContinueButton(with: MediaFileType?) {
        router?.showUploadPostViewController()
    }
    
    func didRequestCellMedia() {
        interactor?.fetchCellMedia()
    }
    
    func didRequestOriginalMedia(at index: Int) {
        interactor?.fetchOriginalMedia(at: index)
    }
}

// MARK: - INewPostInteractorOutput

extension NewPostPresenter: INewPostInteractorOutput {
    func fetchCellMediaSuccess(_ mediaFile: MediaFileType) {
        viewController?.appendCellMediaFile(mediaFile)
    }
    
    func fetchOriginalMediaSuccess(_ mediaFile: MediaFileType, at index: Int) {
        viewController?.setOriginalMediaFile(mediaFile)
    }
}
