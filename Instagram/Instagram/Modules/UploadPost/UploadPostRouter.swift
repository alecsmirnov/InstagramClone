//
//  UploadPostRouter.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

protocol IUploadPostRouter: AnyObject {
    
}

final class UploadPostRouter {
    private weak var viewController: UploadPostViewController?
    
    init(viewController: UploadPostViewController) {
        self.viewController = viewController
    }
}

// MARK: - IUploadPostRouter

extension UploadPostRouter: IUploadPostRouter {
    
}
