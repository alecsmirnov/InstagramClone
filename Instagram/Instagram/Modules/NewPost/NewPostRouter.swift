//
//  NewPostRouter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostRouter: AnyObject {
    func closeNewPostViewController()
    func showUploadPostViewController(mediaFile: MediaFileType)
}

final class NewPostRouter {
    private weak var viewController: NewPostViewController?
    
    init(viewController: NewPostViewController) {
        self.viewController = viewController
    }
}

// MARK: - INewPostRouter

extension NewPostRouter: INewPostRouter {
    func closeNewPostViewController() {
        viewController?.dismiss(animated: true)
    }
    
    func showUploadPostViewController(mediaFile: MediaFileType) {
        let uploadPostViewController = UploadPostAssembly.createUploadPostViewController(mediaFile: mediaFile)
        
        viewController?.navigationController?.pushViewController(uploadPostViewController, animated: true)
    }
}
