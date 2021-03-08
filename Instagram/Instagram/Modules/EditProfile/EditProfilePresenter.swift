//
//  EditProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

protocol IEditProfilePresenter: AnyObject {
    func viewDidLoad()
    
    func didPressCloseButton()
    func didPressEditButton()
    func didPressUsernameTextField()
    func didPressBioTextField()
}

protocol EditProfilePresenterDelegate: AnyObject {
    func editProfilePresenterDidPressEdit(_ editProfilePresenter: EditProfilePresenter)
}

final class EditProfilePresenter {
    weak var viewController: IEditProfileViewController?
    var interactor: IEditProfileInteractor?
    var router: IEditProfileRouter?
    
    var user: User?
    weak var delegate: EditProfilePresenterDelegate?
}

// MARK: - IEditProfilePresenter

extension EditProfilePresenter: IEditProfilePresenter {
    func viewDidLoad() {
        guard let user = user else { return }
        
        viewController?.setUser(user)
    }
    
    func didPressCloseButton() {
        router?.closeEditProfileViewController()
    }
    
    func didPressEditButton() {
        delegate?.editProfilePresenterDidPressEdit(self)
    }
    
    func didPressUsernameTextField() {
        guard let username = user?.username else { return }
        
        router?.showEditProfileUsernameViewController(username: username, delegate: self)
    }
    
    func didPressBioTextField() {
        guard let user = user else { return }
        
        router?.showEditProfileBioViewController(bio: user.bio, delegate: self)
    }
}

// MARK: - IEditProfileInteractorOutput

extension EditProfilePresenter: IEditProfileInteractorOutput {
    
}

// MARK: - EditProfileUsernamePresenterDelegate

extension EditProfilePresenter: EditProfileUsernamePresenterDelegate {
    
}

// MARK: - EditProfileBioPresenterDelegate

extension EditProfilePresenter: EditProfileBioPresenterDelegate {
    func editProfileBioPresenter(_ editProfileBioPresenter: EditProfileBioPresenter, didChangeBio bio: String?) {
        user?.bio = bio
        
        guard let user = user else { return }
        
        viewController?.setUser(user)
    }
}
