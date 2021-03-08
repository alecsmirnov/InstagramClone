//
//  EditProfileUsernameInteractor.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

protocol IEditProfileUsernameInteractor: AnyObject {
    func checkUsername(_ username: String)
}

protocol IEditProfileUsernameInteractorOutput: AnyObject {
    func isValidUsername()
    func isInvalidUsername()
    func isUserWithUsernameExist()
    func isEmptyUsername()
}

final class EditProfileUsernameInteractor {
    weak var presenter: IEditProfileUsernameInteractorOutput?
}

// MARK: - IEditProfileUsernameInteractor

extension EditProfileUsernameInteractor: IEditProfileUsernameInteractor {
    func checkUsername(_ username: String) {
        guard !username.isEmpty else {
            presenter?.isEmptyUsername()
            
            return
        }
        
        guard InputValidation.isValidUsername(username) else {
            presenter?.isInvalidUsername()
            
            return
        }
        
        FirebaseUserService.isUsernameExist(username) { [self] result in
            switch result {
            case .success(let isUsernameExist):
                if isUsernameExist {
                    presenter?.isUserWithUsernameExist()
                } else {
                    presenter?.isValidUsername()
                }
            case .failure(let error):
                print("Failed to fetch username status: \(error.localizedDescription)")
            }
        }
    }    
}
