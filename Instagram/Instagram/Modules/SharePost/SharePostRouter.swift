//
//  SharePostRouter.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

protocol ISharePostRouter: AnyObject {
    
}

final class SharePostRouter {
    private weak var viewController: SharePostViewController?
    
    init(viewController: SharePostViewController) {
        self.viewController = viewController
    }
}

// MARK: - ISharePostRouter

extension SharePostRouter: ISharePostRouter {
    
}
