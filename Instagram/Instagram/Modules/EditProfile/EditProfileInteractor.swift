//
//  EditProfileInteractor.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

protocol IEditProfileInteractor: AnyObject {
    
}

protocol IEditProfileInteractorOutput: AnyObject {
    
}

final class EditProfileInteractor {
    weak var presenter: IEditProfileInteractorOutput?
}

// MARK: - IEditProfileInteractor

extension EditProfileInteractor: IEditProfileInteractor {
    
}
