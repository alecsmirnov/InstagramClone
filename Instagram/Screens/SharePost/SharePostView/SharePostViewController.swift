//
//  SharePostViewController.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol SharePostViewControllerProtocol: AnyObject {
    func setImage(_ image: UIImage)
    
    func showLoadingView()
    func hideLoadingView(completion: (() -> Void)?)
    
    func showAlert()
}

extension SharePostViewControllerProtocol {
    func hideLoadingView() {
        hideLoadingView(completion: nil)
    }
}

protocol SharePostViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapShareButton(withImage image: UIImage, caption: String?)
}

final class SharePostViewController: CustomViewController<SharePostView> {
    // MARK: Properties
    
    var output: SharePostViewControllerOutputProtocol?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private lazy var alertController = SimpleAlert(presentationController: self)
    
    // MARK: Subviews
    
    private lazy var spinnerView = SpinnerView()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        
        output?.viewDidLoad()
    }
}

// MARK: - SharePostViewController Interface

extension SharePostViewController: SharePostViewControllerProtocol {
    func setImage(_ image: UIImage) {
        customView?.image = image
    }
    
    func showLoadingView() {
        navigationController?.view.addSubview(spinnerView)
        spinnerView.show()
    }
    
    func hideLoadingView(completion: (() -> Void)?) {
        spinnerView.hide { [weak self] in
            self?.spinnerView.removeFromSuperview()
            
            completion?()
        }
    }
    
    func showAlert() {
        alertController.showAlert(title: "Can't share post", message: "Sorry, something goes wrong. Please try again")
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
            action: #selector(didTapShareButton))

        navigationItem.rightBarButtonItem = shareBarButtonItem
    }
}

// MARK: - Button Actions

private extension SharePostViewController {
    @objc func didTapShareButton() {
        guard let image = customView?.image else { return }
        
        let caption = customView?.caption
        
        customView?.endEditing(true)
        output?.didTapShareButton(withImage: image, caption: caption)
    }
}
