//
//  ProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfilePresenter: AnyObject {
    
}

final class ProfilePresenter {
    weak var viewController: IProfileViewController?
    var interactor: IProfileInteractor?
    var router: IProfileRouter?
}

// MARK: - IProfilePresenter

extension ProfilePresenter: IProfilePresenter {
    
}
