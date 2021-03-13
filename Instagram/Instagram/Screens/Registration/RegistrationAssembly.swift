//
//  RegistrationAssembly.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

enum RegistrationAssembly {
    static func createRegistrationViewController(
        coordinator: RegistrationCoordinatorProtocol
    ) -> RegistrationViewController {
        let viewController = RegistrationViewController()
        let presenter = RegistrationPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.registrationService = RegistrationService()
        
        return viewController
    }
}
