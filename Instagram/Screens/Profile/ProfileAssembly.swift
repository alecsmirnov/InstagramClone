//
//  ProfileAssembly.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

enum ProfileAssembly {
    static func createProfileViewController(
        menuEnabled: Bool = false,
        user: User? = nil,
        coordinator: ProfileCoordinatorProtocol? = nil
    ) -> ProfileViewController {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.menuEnabled = menuEnabled
        
        presenter.profileService = ProfileService()
        
        presenter.user = user
        
        return viewController
    }
}
