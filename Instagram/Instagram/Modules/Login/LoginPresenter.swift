//
//  LoginPresenter.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

protocol ILoginPresenter {
    func didPressLogInButton()
    func didPressSignUpButton()
}

final class LoginPresenter {
    weak var viewController: ILoginViewController?
    var interactor: ILoginInteractor?
    var router: ILoginRouter?
}

// MARK: - ILoginPresenter

extension LoginPresenter: ILoginPresenter {
    func didPressLogInButton() {
        
    }
    
    func didPressSignUpButton() {
        router?.openRegistrationViewController()
    }
}

// MARK: - ILoginInteractorOutput

extension LoginPresenter: ILoginInteractorOutput {
    
}
