//
//  SharePostInteractor.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

protocol ISharePostInteractor: AnyObject {
    
}

protocol ISharePostInteractorOutput: AnyObject {
    
}

final class SharePostInteractor {
    weak var presenter: ISharePostInteractorOutput?
}

// MARK: - ISharePostInteractor

extension SharePostInteractor: ISharePostInteractor {
    
}
