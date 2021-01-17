//
//  RegistrationPresenter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationPresenter {
    
}

final class RegistrationPresenter {
    weak var viewController: IRegistrationViewController?
    var interactor: IRegistrationInteractor?
    var router: IRegistrationRouter?
}

extension RegistrationPresenter: IRegistrationPresenter {
    
}
