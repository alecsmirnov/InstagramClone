//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol INewPostViewController: AnyObject {
    func setMediaFiles(_ mediaFiles: [MediaFileType])
}

final class NewPostViewController: CustomViewController<NewPostView> {
    // MARK: Properties
    
    var presenter: INewPostPresenter?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Constants
    
    private enum Images {
        static let closeButton = UIImage(systemName: "xmark")
        static let continueButton = UIImage(systemName: "arrow.right")
    }
    
    private enum Constants {
        static let title = "New post"
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - INewPostViewController

extension NewPostViewController: INewPostViewController {
    func setMediaFiles(_ mediaFiles: [MediaFileType]) {
        customView?.setMediaFiles(mediaFiles)
    }
}

// MARK: - Appearance

private extension NewPostViewController {
    func setupAppearance() {
        navigationItem.title = Constants.title
        
        setupCloseButton()
        setupContinueButton()
    }
    
    func setupCloseButton() {
        let closeBarButtonItem = UIBarButtonItem(
            image: Images.closeButton,
            style: .plain,
            target: self,
            action: #selector(didPressCloseButton))
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func setupContinueButton() {
        let continueBarButtonItem = UIBarButtonItem(
            image: Images.continueButton,
            style: .plain,
            target: self,
            action: #selector(didPressContinueButton))
        
        navigationItem.rightBarButtonItem = continueBarButtonItem
    }
}

// MARK: - Actions

private extension NewPostViewController {
    @objc func didPressCloseButton() {
        presenter?.didPressCloseButton()
    }
    
    @objc func didPressContinueButton() {
        presenter?.didPressContinueButton()
    }
}
