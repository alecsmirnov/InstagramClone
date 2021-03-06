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

final class EditProfilePresenter {
    weak var viewController: IEditProfileViewController?
    var interactor: IEditProfileInteractor?
    var router: IEditProfileRouter?
}

// MARK: - IEditProfilePresenter

extension EditProfilePresenter: IEditProfilePresenter {
    func didPressCloseButton() {
        router?.closeEditProfileViewController()
    }
    
    func didPressEditButton() {
        
    }
}

// MARK: - IEditProfileInteractorOutput

extension EditProfilePresenter: IEditProfileInteractorOutput {
    
}
