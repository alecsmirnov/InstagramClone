//
//  ProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfilePresenter: AnyObject {
    func viewDidLoad()
    
    func didPressMenuButton()
}

final class ProfilePresenter {
    weak var viewController: IProfileViewController?
    var interactor: IProfileInteractor?
    var router: IProfileRouter?
    
    var user: User?
}

// MARK: - IProfilePresenter

extension ProfilePresenter: IProfilePresenter {
    func viewDidLoad() {
        if let user = user, let identifier = user.identifier {
            viewController?.setUser(user)
            
            interactor?.fetchPosts(identifier: identifier)
        } else {
            interactor?.fetchCurrentUser()
        }
    }
    
    func didPressMenuButton() {
        // TODO: move to Menu module
        
        interactor?.signOut()
        
        router?.showLoginViewController()
    }
}

// MARK: - IProfileInteractorOutput

extension ProfilePresenter: IProfileInteractorOutput {
    func fetchCurrentUserSuccess(_ user: User) {
        viewController?.setUser(user)
        
        if let identifier = user.identifier {
            interactor?.fetchPosts(identifier: identifier)
        }
    }
    
    func fetchCurrentUserFailure() {
        
    }
    
    func fetchPostsSuccess(_ posts: [Post]) {
        viewController?.setPosts(posts)
    }
    
    func fetchPostsFailure() {
        
    }
}
