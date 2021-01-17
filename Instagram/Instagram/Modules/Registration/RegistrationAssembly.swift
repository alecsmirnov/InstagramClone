//
//  RegistrationAssembly.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

enum RegistrationAssembly {
    static func createRegistrationViewController() -> RegistrationViewController {
        let viewController = RegistrationViewController()
        
        let interactor = RegistrationInteractor()
        let presenter = RegistrationPresenter()
        let router = RegistrationRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        return viewController
    }
}
