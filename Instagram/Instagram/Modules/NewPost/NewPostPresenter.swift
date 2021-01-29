//
//  NewPostPresenter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostPresenter: AnyObject {
    func didPressCloseButton()
    func didPressContinueButton()
    
    func viewDidLoad()
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
    
    func viewDidLoad() {
        guard let mediaFiles = interactor?.fetchMediaFiles() else { return }
        
        viewController?.setMediaFiles(mediaFiles)
    }
}

// MARK: - INewPostInteractorOutput

extension NewPostPresenter: INewPostInteractorOutput {
    
}
