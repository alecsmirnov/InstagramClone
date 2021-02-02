//
//  UploadPostViewController.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol IUploadPostViewController: AnyObject {
    func setMediaFile(_ mediaFile: MediaFileType)
}

final class UploadPostViewController: CustomViewController<UploadPostView> {
    // MARK: Properties
    
    var presenter: IUploadPostPresenter?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - IUploadPostViewController

extension UploadPostViewController: IUploadPostViewController {
    func setMediaFile(_ mediaFile: MediaFileType) {
        customView?.setMediaFile(mediaFile)
    }
}

// MARK: - Appearance

private extension UploadPostViewController {
    func setupAppearance() {
        setupUploadButton()
    }
    
    func setupUploadButton() {
        let uploadBarButtonItem = UIBarButtonItem(
            image: UploadPostConstants.Images.uploadButton,
            style: .plain,
            target: self,
            action: #selector(didPressUploadButton))

        navigationItem.rightBarButtonItem = uploadBarButtonItem
    }
}

// MARK: - Actions

private extension UploadPostViewController {
    @objc func didPressUploadButton() {
        presenter?.didPressUploadButton()
    }
}
