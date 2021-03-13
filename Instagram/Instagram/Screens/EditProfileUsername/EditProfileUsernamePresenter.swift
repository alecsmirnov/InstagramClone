//
//  EditProfileUsernamePresenter.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

protocol IEditProfileUsernamePresenter: AnyObject {
    func viewDidLoad()
    
    func didPressCloseButton()
    func didPressEditButton(with username: String)
    func didChangeUsername(_ username: String)
}

protocol EditProfileUsernamePresenterDelegate: AnyObject {
    func editProfileUsernamePresenter(
        _ editProfileUsernamePresenter: EditProfileUsernamePresenter,
        didChangeUsername username: String)
}

final class EditProfileUsernamePresenter {
    weak var viewController: IEditProfileUsernameViewController?
    var interactor: IEditProfileUsernameInteractor?
    var router: IEditProfileUsernameRouter?
    
    var username: String?
    var currentUsername: String?
    weak var delegate: EditProfileUsernamePresenterDelegate?
}

// MARK: - IEditProfileUsernamePresenter

extension EditProfileUsernamePresenter: IEditProfileUsernamePresenter {
    func viewDidLoad() {
        guard let username = username else { return }
        
        viewController?.setUsername(username)
    }
    
    func didPressCloseButton() {
        router?.closeEditProfileUsernameViewController()
    }
    
    func didPressEditButton(with username: String) {
        delegate?.editProfileUsernamePresenter(self, didChangeUsername: username)
        
        router?.closeEditProfileUsernameViewController()
    }
    
    func didChangeUsername(_ username: String) {
        guard username != currentUsername else {
            viewController?.enableEditButton()
            
            return
        }
        
        viewController?.showActivityIndicator()
        viewController?.disableEditButton()
        
        interactor?.checkUsername(username)
    }
}

// MARK: - IEditProfileUsernameInteractorOutput

extension EditProfileUsernamePresenter: IEditProfileUsernameInteractorOutput {
    func isValidUsername() {
        viewController?.hideActivityIndicator()
        viewController?.enableEditButton()
    }
    
    func isInvalidUsername() {
        viewController?.hideActivityIndicator()
        viewController?.showInvalidUsernameAlert()
    }
    
    func isUserWithUsernameExist() {
        viewController?.hideActivityIndicator()
        viewController?.showAlreadyInUseUsernameAlert()
    }
    
    func isEmptyUsername() {
        viewController?.hideActivityIndicator()
    }
}
