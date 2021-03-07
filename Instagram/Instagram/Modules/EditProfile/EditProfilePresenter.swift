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
}

// MARK: - IEditProfileInteractorOutput

extension EditProfilePresenter: IEditProfileInteractorOutput {
    
}
