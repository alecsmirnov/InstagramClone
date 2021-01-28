//
//  HomeInteractor.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomeInteractor: AnyObject {
    
}

protocol IHomeInteractorOutput: AnyObject {

}

final class HomeInteractor {
    weak var presenter: IHomeInteractorOutput?
}

// MARK: - IHomeInteractor

extension HomeInteractor: IHomeInteractor {
    
}

