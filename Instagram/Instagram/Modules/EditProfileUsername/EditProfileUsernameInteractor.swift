//
//  EditProfileUsernameInteractor.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

protocol IEditProfileUsernameInteractor: AnyObject {
    
}

protocol IEditProfileUsernameInteractorOutput: AnyObject {
    
}

final class EditProfileUsernameInteractor {
    weak var presenter: IEditProfileUsernameInteractorOutput?
}

// MARK: - IEditProfileUsernameInteractor

extension EditProfileUsernameInteractor: IEditProfileUsernameInteractor {
    
}
