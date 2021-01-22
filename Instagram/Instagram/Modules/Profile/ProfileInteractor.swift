//
//  ProfileInteractor.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfileInteractor: AnyObject {
    func fetchUser()
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
        guard let identifier = FirebaseUserService.currentUserIdentifier else { return }
        
        FirebaseUserService.fetchUser(withIdentifier: identifier) { [self] user in
            guard let user = user else {
                presenter?.fetchUserFailure()
                
                return
            }
            
            presenter?.fetchUserSuccess(user)
        }
    }
}
