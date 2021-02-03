//
//  SharePostViewController.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol ISharePostViewController: AnyObject {
    func setMediaFile(_ mediaFile: MediaFileType)
}

final class SharePostViewController: CustomViewController<SharePostView> {
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

// MARK: - ISharePostViewController

extension SharePostViewController: ISharePostViewController {
    func setMediaFile(_ mediaFile: MediaFileType) {
        customView?.setMediaFile(mediaFile)
    }
}

// MARK: - Appearance

private extension SharePostViewController {
    func setupAppearance() {
        navigationItem.title = SharePostConstants.Constants.title
        
        customizeBackButton()
        setupShareButton()
    }
    
    func customizeBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        backBarButtonItem.tintColor = .black
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    func setupShareButton() {
        let shareBarButtonItem = UIBarButtonItem(
            title: SharePostConstants.Constants.shareButtonTitle,
            style: .plain,
            target: self,
            action: #selector(didPressShareButton))

        navigationItem.rightBarButtonItem = shareBarButtonItem
    }
}

// MARK: - Actions

private extension SharePostViewController {
    @objc func didPressShareButton() {
        presenter?.didPressShareButton()
    }
}
