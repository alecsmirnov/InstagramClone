//
//  ProfileAssembly.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

enum ProfileAssembly {
    static func createProfileViewController(
        user: User? = nil,
        coordinator: ProfileCoordinatorProtocol? = nil
    ) -> ProfileViewController {
        let viewController = ProfileViewController()
        
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter(viewController: viewController)
        
        viewController.output = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.user = user
        
        return viewController
    }
}
