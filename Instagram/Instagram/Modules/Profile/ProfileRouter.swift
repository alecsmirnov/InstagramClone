//
//  ProfileRouter.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfileRouter: AnyObject {
    func showFollowersViewController(user: User, userStats: UserStats)
    func showFollowingViewController(user: User, userStats: UserStats)
    func showEditProfileViewController(delegate: EditProfilePresenterDelegate)
    
    func showLoginViewController()
}

final class ProfileRouter {
    private weak var viewController: ProfileViewController?
    
    init(viewController: ProfileViewController) {
        self.viewController = viewController
    }
}

// MARK: - IProfileRouter

extension ProfileRouter: IProfileRouter {
    func showFollowersViewController(user: User, userStats: UserStats) {
        let followersViewController = FollowersFollowingAssembly.createFollowersViewController(
            user: user,
            userStats: userStats)
        
        viewController?.navigationController?.pushViewController(followersViewController, animated: true)
    }
    
    func showFollowingViewController(user: User, userStats: UserStats) {
        let followingViewController = FollowersFollowingAssembly.createFollowingViewController(
            user: user,
            userStats: userStats)
        
        viewController?.navigationController?.pushViewController(followingViewController, animated: true)
    }
    
    func showEditProfileViewController(delegate: EditProfilePresenterDelegate) {
        let editProfileViewController = EditProfileAssembly.createEditProfileNavigationViewController(
            delegate: delegate)
        
        editProfileViewController.modalPresentationStyle = .fullScreen
        
        viewController?.tabBarController?.present(editProfileViewController, animated: true)
    }
    
    func showLoginViewController() {
        let loginViewController = LoginAssembly.createLoginViewController()
        
        RootViewControllerSwitcher.setRootViewController(loginViewController)
    }
}
