//
//  HomeRouter.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomeRouter: AnyObject {
    
}

final class HomeRouter {
    private weak var viewController: HomeViewController?
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
    }
}

// MARK: - IHomeRouter

extension HomeRouter: IHomeRouter {
    
}
