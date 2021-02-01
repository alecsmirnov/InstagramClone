//
//  UploadPostInteractor.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

protocol IUploadPostInteractor: AnyObject {
    
}

protocol IUploadPostInteractorOutput: AnyObject {
    
}

final class UploadPostInteractor {
    weak var presenter: IUploadPostInteractorOutput?
}

// MARK: - IUploadPostInteractor

extension UploadPostInteractor: IUploadPostInteractor {
    
}
