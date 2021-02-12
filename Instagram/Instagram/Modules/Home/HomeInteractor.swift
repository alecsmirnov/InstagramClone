//
//  HomeInteractor.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomeInteractor: AnyObject {
    func fetchUserPosts()
}

protocol IHomeInteractorOutput: AnyObject {
    func fetchUserPostSuccess(_ userPost: UserPost)
    func fetchUserPostFailure()
}

final class HomeInteractor {
    weak var presenter: IHomeInteractorOutput?
}

// MARK: - IHomeInteractor

extension HomeInteractor: IHomeInteractor {    
    func fetchUserPosts() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebasePostService.fetchUserPosts(identifier: identifier) { [self] result in
            switch result {
            case .success(let userPost):
                presenter?.fetchUserPostSuccess(userPost)
            case .failure(let error):
                presenter?.fetchUserPostFailure()
                
                print("Failed to fetch user post: \(error.localizedDescription)")
            }
        }
    }
}

