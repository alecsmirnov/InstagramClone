//
//  EditProfileUsernamePresenter.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

protocol EditProfileUsernamePresenterDelegate: AnyObject {
    func editProfileUsernamePresenter(
        _ editProfileUsernamePresenter: EditProfileUsernamePresenter,
        didChangeUsername username: String)
}

final class EditProfileUsernamePresenter {
    weak var view: EditProfileUsernameViewControllerProtocol?
    weak var coordinator: EditProfileUsernameCoordinatorProtocol?
    
    weak var delegate: EditProfileUsernamePresenterDelegate?
    
    var editProfileUsernameService: EditProfileUsernameServiceProtocol?
    
    var username: String?
    var currentUsername: String?
}

// MARK: - EditProfileUsernameView Output

extension EditProfileUsernamePresenter: EditProfileUsernameViewControllerOutputProtocol {
    func viewDidLoad() {
        guard let username = username, !username.isEmpty else {
            view?.disableEditButton()
            
            return
        }
        
        view?.setUsername(username)
    }
    
    func didTapCloseButton() {
        coordinator?.closeEditProfileUsernameViewController()
    }
    
    func didTapEditButton(withUsername username: String) {
        delegate?.editProfileUsernamePresenter(self, didChangeUsername: username)
        
        coordinator?.closeEditProfileUsernameViewController()
    }
    
    func didChangeUsername(_ username: String) {
        guard username != currentUsername else {
            view?.enableEditButton()
            
            return
        }
        
        view?.showActivityIndicator()
        view?.disableEditButton()
        
        editProfileUsernameService?.checkUsername(username) { [weak self] result in
            self?.view?.hideActivityIndicator()
            
            switch result {
            case .validUsername:
                self?.view?.enableEditButton()
            case .invalidUsername:
                self?.view?.showInvalidUsernameAlert()
            case .usernameExist:
                self?.view?.showAlreadyInUseUsernameAlert()
            case .isEmptyUsername:
                break
            }
        }
    }
}
