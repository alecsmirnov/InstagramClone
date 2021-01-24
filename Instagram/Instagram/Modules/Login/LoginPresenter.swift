//
//  LoginPresenter.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

protocol ILoginPresenter {

}

final class LoginPresenter {
    weak var viewController: ILoginViewController?
    var interactor: ILoginInteractor?
    var router: ILoginRouter?
}

// MARK: - ILoginPresenter

extension LoginPresenter: ILoginPresenter {

}

// MARK: - ILoginInteractorOutput

extension LoginPresenter: ILoginInteractorOutput {
    
}
