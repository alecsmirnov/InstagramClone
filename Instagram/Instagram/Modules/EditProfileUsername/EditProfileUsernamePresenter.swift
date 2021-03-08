//
//  EditProfileUsernamePresenter.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

protocol IEditProfileUsernamePresenter: AnyObject {
    func viewDidLoad()
    
    func didPressCloseButton()
    func didPressEditButton()
}

protocol EditProfileUsernamePresenterDelegate: AnyObject {
    
}

final class EditProfileUsernamePresenter {
    weak var viewController: IEditProfileUsernameViewController?
    var interactor: IEditProfileUsernameInteractor?
    var router: IEditProfileUsernameRouter?
    
    var username: String?
    weak var delegate: EditProfileUsernamePresenterDelegate?
}

// MARK: - IEditProfileUsernamePresenter

extension EditProfileUsernamePresenter: IEditProfileUsernamePresenter {
    func viewDidLoad() {
        
    }
    
    func didPressCloseButton() {
        router?.closeEditProfileUsernameViewController()
    }
    
    func didPressEditButton() {
        
    }
}

// MARK: - IEditProfileUsernameInteractorOutput

extension EditProfileUsernamePresenter: IEditProfileUsernameInteractorOutput {
    
}
