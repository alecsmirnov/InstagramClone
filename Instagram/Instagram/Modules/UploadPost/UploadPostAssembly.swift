//
//  UploadPostAssembly.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

enum UploadPostAssembly {
    static func createUploadPostViewController(mediaFile: MediaFileType) -> UploadPostViewController {
        let viewController = UploadPostViewController()
        
        let interactor = UploadPostInteractor()
        let presenter = UploadPostPresenter()
        let router = UploadPostRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.mediaFile = mediaFile
        
        return viewController
    }
}
