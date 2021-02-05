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
}

// MARK: - IProfilePresenter

extension ProfilePresenter: IProfilePresenter {
    func viewDidLoad() {
        print("VIEW DID LOAD")
        
        //interactor?.fetchUser()
        interactor?.fetchPosts()
    }
    
    func didPressMenuButton() {
        // TODO: move to Menu module
        
        interactor?.signOut()
        
        router?.showLoginViewController()
    }
}

// MARK: - IProfileInteractorOutput

extension ProfilePresenter: IProfileInteractorOutput {
    func fetchUserSuccess(_ user: User) {
        viewController?.setUser(user)
    }
    
    func fetchUserFailure() {
        
    }
    
    func fetchPostsSuccess(_ posts: [Post]) {
        viewController?.setPosts(posts)
    }
    
    func fetchPostsFailure() {
        
    }
}
