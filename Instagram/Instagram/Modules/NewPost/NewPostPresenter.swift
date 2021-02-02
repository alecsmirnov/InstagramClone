//
//  NewPostPresenter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostPresenter: AnyObject {
    func didPressCloseButton()
    func didPressNextButton(with mediaFile: MediaFileType?)
    
    func didRequestCellMediaFile()
    func didRequestOriginalMediaFile(at index: Int)
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
    
    func didPressNextButton(with mediaFile: MediaFileType?) {
        guard let mediaFile = mediaFile else { return }
        
        router?.showSharePostViewController(mediaFile: mediaFile)
    }
    
    func didRequestCellMediaFile() {
        interactor?.fetchCellMediaFile()
    }
    
    func didRequestOriginalMediaFile(at index: Int) {
        interactor?.fetchOriginalMediaFile(at: index)
        
        viewController?.disableNextButton()
    }
}

// MARK: - INewPostInteractorOutput

extension NewPostPresenter: INewPostInteractorOutput {
    func fetchCellMediaFileSuccess(_ mediaFile: MediaFileType) {
        viewController?.appendCellMediaFile(mediaFile)
    }
    
    func fetchOriginalMediaFileSuccess(_ mediaFile: MediaFileType, at index: Int) {
        viewController?.setOriginalMediaFile(mediaFile)
        
        viewController?.enableNextButton()
    }
}
