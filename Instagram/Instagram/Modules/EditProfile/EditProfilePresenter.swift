//
//  EditProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

protocol IEditProfilePresenter: AnyObject {
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
    
    weak var delegate: EditProfilePresenterDelegate?
}

// MARK: - IEditProfilePresenter

extension EditProfilePresenter: IEditProfilePresenter {
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
