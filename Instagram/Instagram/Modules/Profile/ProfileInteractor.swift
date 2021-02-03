//
//  ProfileInteractor.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfileInteractor: AnyObject {
    func fetchUser()
    
    // TODO: move to Menu module
    
    func signOut()
}

protocol IProfileInteractorOutput: AnyObject {
    func fetchUserSuccess(_ user: User)
    func fetchUserFailure()
}

final class ProfileInteractor {
    weak var presenter: IProfileInteractorOutput?
}

// MARK: - IProfileInteractor

extension ProfileInteractor: IProfileInteractor {
    func fetchUser() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseUserService.fetchUser(withIdentifier: identifier) { [self] result in
            switch result {
            case .success(let user):
                presenter?.fetchUserSuccess(user)
            case .failure(let error):
                presenter?.fetchUserFailure()
                
                print("Failed to fetch user: \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() {
        FirebaseAuthService.signOut()
    }
}
