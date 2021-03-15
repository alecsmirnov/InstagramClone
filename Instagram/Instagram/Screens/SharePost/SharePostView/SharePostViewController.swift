//
//  SharePostViewController.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol ISharePostViewController: AnyObject {
    func setImage(_ image: UIImage)
    
    func showSpinner()
    func hideSpinner()
}

final class SharePostViewController: CustomViewController<SharePostView> {
    // MARK: Properties
    
    var presenter: ISharePostPresenter?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Constants
    
    private enum Constants {
        static let shareButtonAnimationDuration: TimeInterval = 0.4
        static let shareButtonEnableAlpha: CGFloat = 1
        static let shareButtonDisableAlpha: CGFloat = 0.8
    }
    
    // MARK: Subviews
    
    private lazy var spinnerView = SpinnerView()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - ISharePostViewController

extension SharePostViewController: ISharePostViewController {
    func setImage(_ image: UIImage) {
        customView?.image = image
    }
    
    func showSpinner() {
        navigationController?.view.addSubview(spinnerView)
        spinnerView.show()
        
        changeShareButtonStatus(isEnabled: false)
    }
    
    func hideSpinner() {
        spinnerView.hide { [weak self] in
            self?.spinnerView.removeFromSuperview()
        }
        
        changeShareButtonStatus(isEnabled: true)
    }
}

// MARK: - Appearance

private extension SharePostViewController {
    func setupAppearance() {
        navigationItem.title = "New post"
        
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
            title: "Share",
            style: .plain,
            target: self,
            action: #selector(didPressShareButton))

        navigationItem.rightBarButtonItem = shareBarButtonItem
    }
    
    func changeShareButtonStatus(isEnabled: Bool) {
        let shareButton = navigationItem.rightBarButtonItem
        
        shareButton?.isEnabled = isEnabled
        
        UIView.animate(withDuration: Constants.shareButtonAnimationDuration) {
            shareButton?.customView?.alpha = isEnabled ?
                Constants.shareButtonEnableAlpha :
                Constants.shareButtonDisableAlpha
        }
    }
}

// MARK: - Actions

private extension SharePostViewController {
    @objc func didPressShareButton() {
        guard let image = customView?.image else { return }
        
        customView?.endEditing(true)
        presenter?.didPressShareButton(withMediaFile: image, caption: customView?.caption)
    }
}
