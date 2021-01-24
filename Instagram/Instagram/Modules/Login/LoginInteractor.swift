//
//  LoginInteractor.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

protocol ILoginInteractor: AnyObject {

}

protocol ILoginInteractorOutput: AnyObject {

}

final class LoginInteractor {
    weak var presenter: ILoginInteractorOutput?
}

// MARK: - ILoginInteractor

extension LoginInteractor: ILoginInteractor {

}
