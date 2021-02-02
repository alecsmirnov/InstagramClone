//
//  UploadPostViewController.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol IUploadPostViewController: AnyObject {
    
}

final class UploadPostViewController: CustomViewController<UploadPostView> {
    // MARK: Properties
    
    var presenter: IUploadPostPresenter?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Constants
    
    enum Images {
        static let uploadButton = UIImage(systemName: "checkmark")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - IUploadPostViewController

extension UploadPostViewController: IUploadPostViewController {
    
}

// MARK: - Appearance

private extension UploadPostViewController {
    func setupAppearance() {
        setupUploadButton()
    }
    
    func setupUploadButton() {
        let uploadBarButtonItem = UIBarButtonItem(
            image: Images.uploadButton,
            style: .plain,
            target: self,
            action: #selector(didPressUploadButton))

        navigationItem.rightBarButtonItem = uploadBarButtonItem
    }
}

// MARK: - Actions

private extension UploadPostViewController {
    @objc func didPressUploadButton() {
        
    }
}
