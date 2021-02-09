//
//  HomeInteractor.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomeInteractor: AnyObject {
    func fetchPosts()
}

protocol IHomeInteractorOutput: AnyObject {
    func fetchPostsSuccess(_ posts: [Post])
    func fetchPostsFailure()
}

final class HomeInteractor {
    weak var presenter: IHomeInteractorOutput?
}

// MARK: - IHomeInteractor

extension HomeInteractor: IHomeInteractor {
    func fetchPosts() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebasePostService.fetchPosts(identifier: identifier) { [self] result in
            switch result {
            case .success(let posts):
                presenter?.fetchPostsSuccess(posts)
            case .failure(let error):
                presenter?.fetchPostsFailure()
                
                print("Failed to fetch posts: \(error.localizedDescription)")
            }
        }
    }
}

