//
//  SharePostViewController.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol ISharePostViewController: AnyObject {
    func setMediaFile(_ mediaFile: MediaFileType)
    
    func showSpinner()
    func hideSpinner()
}

final class SharePostViewController: CustomViewController<SharePostView> {
    // MARK: Properties
    
    var presenter: ISharePostPresenter?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Child View Controllers
    
    private let spinnerViewController = SpinnerViewController(statusBarHidden: true)
    
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
    
    func showSpinner() {
        navigationController?.add(spinnerViewController)
        
        spinnerViewController.show()
    }
    
    func hideSpinner() {
        spinnerViewController.hide()
        spinnerViewController.remove()
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
        guard let image = customView?.image else { return }
        
        presenter?.didPressShareButton(withMediaFile: .image(image), caption: customView?.caption)
    }
}
