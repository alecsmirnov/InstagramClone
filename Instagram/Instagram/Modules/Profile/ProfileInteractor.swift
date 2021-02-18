//
//  ProfileInteractor.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfileInteractor: AnyObject {
    func fetchCurrentUser()
    func fetchPosts(identifier: String)
    
    // TODO: move to Menu module
    
    func signOut()
}

protocol IProfileInteractorOutput: AnyObject {
    func fetchCurrentUserSuccess(_ user: User)
    func fetchCurrentUserFailure()
    
    func fetchPostsSuccess(_ posts: [Post])
    func fetchPostsFailure()
}

final class ProfileInteractor {
    weak var presenter: IProfileInteractorOutput?
}

// MARK: - IProfileInteractor

extension ProfileInteractor: IProfileInteractor {
    func fetchCurrentUser() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseUserService.fetchUser(withIdentifier: identifier) { [self] result in
            switch result {
            case .success(let user):
                presenter?.fetchCurrentUserSuccess(user)
            case .failure(let error):
                presenter?.fetchCurrentUserFailure()
                
                print("Failed to fetch user: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPosts(identifier: String) {
        FirebasePostService.fetchAllPosts(identifier: identifier) { [self] result in
            switch result {
            case .success(let posts):
                presenter?.fetchPostsSuccess(posts)
            case .failure(let error):
                presenter?.fetchPostsFailure()
                
                print("Failed to fetch posts: \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() {
        FirebaseAuthService.signOut()
    }
}
